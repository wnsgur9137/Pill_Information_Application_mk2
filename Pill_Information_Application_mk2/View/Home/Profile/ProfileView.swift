//
//  ProfileView.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth

final class ProfileView: UIViewController {
    
    let disposeBag = DisposeBag()
    
    private lazy var userImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var userUpdateButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원 정보 변경", for: .normal)
        return button
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        return button
    }()
    
    private lazy var bookmarkLabel: UILabel = {
        let label = UILabel()
        label.text = "즐겨찾기"
        label.font = .systemFont(ofSize: 17.0, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private lazy var resetBookmarkButton: UIButton = {
        let button = UIButton()
        button.setTitle("즐겨찾기 초기화", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .regular)
        return button
    }()
    
    
    private lazy var userStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            userImageView,
            logoutButton
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            userNameLabel,
            userUpdateButton
        ])
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var bookmarkStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            bookmarkLabel,
            resetBookmarkButton
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Profile"
        bind()
        setupLayout()
    }
}

private extension ProfileView {
    func bind() {
        
        logoutButton.rx.tap
            .subscribe(onNext: {
                do {
                    // 자동 로그인 제거
                    UserDefaults.standard.removeObject(forKey: "loginType")
                    UserDefaults.standard.removeObject(forKey: "email")
                    UserDefaults.standard.removeObject(forKey: "passwd")
                    
                    // 로그아웃
                    try Auth.auth().signOut()
                    let vc = MainViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                } catch let signOutError as NSError {
                    print("ERROR: signout \(signOutError.localizedDescription)")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setupLayout() {
        [
            userStackView,
            bookmarkStackView
        ].forEach{ view.addSubview($0) }
        
        userStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        bookmarkStackView.snp.makeConstraints {
            $0.top.equalTo(userStackView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        resetBookmarkButton.snp.makeConstraints {
            $0.width.equalTo(150)
        }
    }
}
