//
//  ProfileViewController.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/22.
//

import UIKit
import SnapKit

import Firebase
import FirebaseAuth

final class ProfileViewController: UIViewController {
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var userImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "person")
        image.backgroundColor = .gray
        return image
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var userUpdateButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원 정보 변경", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(userUpdateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var bookmarkLabel: UILabel = {
        let label = UILabel()
        label.text = "즐겨찾기"
        label.font = .systemFont(ofSize: 17.0, weight: .regular)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private lazy var resetBookmarkButton: UIButton = {
        let button = UIButton()
        button.setTitle("즐겨찾기 초기화", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .regular)
        button.addTarget(self, action: #selector(resetBookmarkButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var userStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            userImageView,
            userInfoStackView,
            logoutButton
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 20.0
        stackView.layer.borderColor = UIColor.gray.cgColor
        stackView.layer.borderWidth = 1.0
        stackView.layer.cornerRadius = 8.0
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
    
    private lazy var bookmarkTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Profile"
        self.bookmarkTableView.delegate = self
        self.bookmarkTableView.dataSource = self
        setupLayout()
        setupLayoutInfo()
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if bookmarkList.count == 0 {
//            emptyView.isHidden = false
//        } else {
//            emptyView.isHidden = true
//        }
//        return bookmarkList.count
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if pillList.count == 0 {
//            self.resetStarList(self.resetStarListButton)
//            return UITableViewCell()
//        }
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PillListCell", for: indexPath) as? PillListCell else { return UITableViewCell() }
//        cell.nameLabel.text = "\(String(describing: pillList[indexPath.row].medicineName ?? ""))"
//        cell.etcLabel.text = "\(String(describing: pillList[indexPath.row].etcOtcName ?? ""))"
//        cell.classLabel.text = "\(String(describing: pillList[indexPath.row].className ?? ""))"
//        let imageURL = URL(string: pillList[indexPath.row].medicineImage ?? "")
//        cell.pillImageView.kf.setImage(with: imageURL)
//        return cell
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
}

private extension ProfileViewController {
    
    @objc func logoutButtonTapped() {
        let alertCon = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let alertActCancel = UIAlertAction(title: "아니오", style: UIAlertAction.Style.default)
        let alertActSure = UIAlertAction(title: "예", style: UIAlertAction.Style.destructive, handler: { [weak self] _ in
            self?.logout()
        })
        alertCon.addAction(alertActCancel)
        alertCon.addAction(alertActSure)
        present(alertCon, animated: true)
    }
    
    @objc func userUpdateButtonTapped() {
        let vc = ProfileUpdateViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func logout() {
        do {
            // 자동 로그인 제거
            UserDefaults.standard.removeObject(forKey: "loginType")
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "passwd")
            UserDefaults.standard.removeObject(forKey: "nickname")
            
            // 로그아웃
            try Auth.auth().signOut()
            let vc = MainViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print("ERROR: signout \(signOutError.localizedDescription)")
        }
    }
    
    @objc func resetBookmarkButtonTapped() {
        
    }
    
    func setupLayoutInfo() {
        userNameLabel.text = "\(String(describing: UserDefaults.standard.string(forKey: "nickname")!)) 님"
    }
    
    func setupLayout() {
        [
            backgroundView,
            userStackView,
            bookmarkStackView,
            bookmarkTableView
        ].forEach{ view.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        userImageView.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(80)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.width.equalTo(120)
        }
        
        userStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(80)
            $0.width.equalTo(340)
        }
        
        bookmarkStackView.snp.makeConstraints {
            $0.top.equalTo(userStackView.snp.bottom).offset(50)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
//            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        bookmarkLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
        }
        
        resetBookmarkButton.snp.makeConstraints {
            $0.width.equalTo(150)
        }
        
        bookmarkTableView.snp.makeConstraints {
            $0.top.equalTo(bookmarkStackView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
