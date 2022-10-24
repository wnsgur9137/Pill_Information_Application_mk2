//
//  FindEmailView.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

import Firebase

final class FindEmailView: UIViewController {
    
    let disposeBag = DisposeBag()
    let db = Firestore.firestore()
    let userDB = Firestore.firestore().collection("USER")
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4.0
        imageView.image = UIImage(named: "sign_with")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일 찾기"
        label.textColor = .label
        label.font = .systemFont(ofSize: 20.0, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private lazy var findEmailButton: UIButton = {
        let button = UIButton()
        button.setTitle("이메일 찾기", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        return button
    }()
    
    
    private lazy var nicknameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nicknameLabel,
            nicknameTextField
        ])
        stackView.axis = .horizontal
        stackView.spacing = 6.0
        stackView.distribution = .fill
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "이메일 찾기"
        bind()
        setupLayout()
    }
}

private extension FindEmailView {
    func bind() {
        findEmailButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let query = self.userDB.whereField("NickName", isEqualTo: self.nicknameTextField.text!)
                query.getDocuments { (qs, err) in
                    if qs!.documents.isEmpty {
                        let alertCon = UIAlertController(title: "경고", message: "회원 정보가 없습니다.", preferredStyle: UIAlertController.Style.alert)
                        let alertAct = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                        alertCon.addAction(alertAct)
                        self.present(alertCon, animated: true, completion: nil)
                    } else {
                        for document in qs!.documents {
                            print("-------------------------")
                            print("-------------------------")
                            print("Email: \(document.data()["Email"]!)")
                            print("-------------------------")
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setupLayout() {
        [
            imageView,
            titleLabel,
            nicknameStackView,
            findEmailButton
        ].forEach{ view.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(350)
            $0.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(90)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.width.equalTo(100)
        }

        nicknameStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(90)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(320)
            $0.height.equalTo(34)
        }

        findEmailButton.snp.makeConstraints {
            $0.top.equalTo(nicknameStackView.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(34)
        }
    }
}
