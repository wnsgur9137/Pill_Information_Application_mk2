//
//  EmailLoginView.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

import Firebase
import FirebaseAuth

final class EmailLoginViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let db = Firestore.firestore()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4.0
//        imageView.layer.borderWidth = 2.0
//        imageView.layer.borderColor = UIColor.systemMint.cgColor
        imageView.image = UIImage(named: "sign_with")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Email Login"
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 20.0, weight: .regular)
        titleLabel.textAlignment = .center
        
        return titleLabel
    }()
    
    private lazy var emailLabel: UILabel = {
        let emailLabel = UILabel()
        emailLabel.text = "Email"
        emailLabel.textColor = .label
        emailLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        emailLabel.textAlignment = .center
        
        return emailLabel
    }()
    
    private lazy var emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.backgroundColor = .systemGray
        emailTextField.keyboardType = .emailAddress
        
        
        return emailTextField
    }()
    
    private lazy var passwdLabel: UILabel = {
        let passwdLabel = UILabel()
        passwdLabel.text = "Password"
        passwdLabel.textColor = .label
        passwdLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        passwdLabel.textAlignment = .center
        
        return passwdLabel
    }()
    
    private lazy var passwdTextField: UITextField = {
        let passwdTextField = UITextField()
        passwdTextField.backgroundColor = .systemGray
        passwdTextField.isSecureTextEntry = true
        
        return passwdTextField
    }()
    
    private lazy var signinButton: UIButton = {
        let signinButton = UIButton()
        signinButton.setTitle("Signin", for: .normal)
        signinButton.setTitleColor(.label, for: .normal)
        signinButton.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        
        return signinButton
    }()
    
    private lazy var findEmailButton: UIButton = {
        let findEmailButton = UIButton()
        findEmailButton.setTitle("이메일 찾기", for: .normal)
        findEmailButton.setTitleColor(.label, for: .normal)
        findEmailButton.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        
        return findEmailButton
    }()
    
    private lazy var findPasswdButton: UIButton = {
        let findPasswdButton = UIButton()
        findPasswdButton.setTitle("비밀번호 찾기", for: .normal)
        findPasswdButton.setTitleColor(.label, for: .normal)
        findPasswdButton.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        
        return findPasswdButton
    }()
    
    private lazy var signupButton: UIButton = {
        let signupButton = UIButton()
        signupButton.setTitle("SignUp", for: .normal)
        signupButton.setTitleColor(.label, for: .normal)
        signupButton.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        
        return signupButton
    }()
    
    private lazy var emailStackView: UIStackView = {
        let emailStackView = UIStackView(arrangedSubviews: [
            emailLabel,
            emailTextField
        ])
        
        emailStackView.axis = .horizontal
        emailStackView.spacing = 6.0
        emailStackView.distribution = .fill
        
        return emailStackView
    }()
    
    private lazy var passwdStackView: UIStackView = {
        let passwdStackView = UIStackView(arrangedSubviews: [
            passwdLabel,
            passwdTextField
        ])
        
        passwdStackView.axis = .horizontal
        passwdStackView.spacing = 6.0
        passwdStackView.distribution = .fill
        
        return passwdStackView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            findEmailButton,
            findPasswdButton,
            signupButton
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 6.0
        stackView.distribution = .fill
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "EmailLogin"
        
        bind()
        setupLayout()
    }
}

private extension EmailLoginViewController {
    
    func bind() {
        
        signupButton.rx.tap
            .bind {
                let vc = EmailSignUpViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        findEmailButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let vc = FindEmailView()
                vc.modalPresentationStyle = .fullScreen
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        findPasswdButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let vc = FindPasswdView()
                vc.modalPresentationStyle = .fullScreen
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        signinButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if self.emailTextField.text != "" && self.passwdTextField.text != "" {
                    
                    Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwdTextField.text!) { (user, error) in
                        
                        if user != nil {
                            UserDefaults.standard.set("email", forKey: "loginType")
                            UserDefaults.standard.set(self.emailTextField.text!, forKey: "email")
                            UserDefaults.standard.set(self.passwdTextField.text!, forKey: "passwd")
                            let userDB = self.db.collection("USER")
                            let query = userDB.whereField("Email", isEqualTo: self.emailTextField.text!)
                            query.getDocuments { (qs, err) in
                                if qs!.documents.isEmpty {
                                    let alertCon = UIAlertController(title: "경고", message: "회원 정보가 없습니다.", preferredStyle: UIAlertController.Style.alert)
                                    let alertAct = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                                    alertCon.addAction(alertAct)
                                    self.present(alertCon, animated: true, completion: nil)
                                } else {
                                    for document in qs!.documents {
                                        UserDefaults.standard.set(document.data()["NickName"]!, forKey: "nickname")
                                    }
                                }
                            }
                            
                            let vc = HomeTabBarController()
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true)
                        } else {
                            let alertCon = UIAlertController(title: "경고", message: "이메일과 비밀번호를 확인해 주십시오.", preferredStyle: UIAlertController.Style.alert)
                            let alertAct = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                            alertCon.addAction(alertAct)
                            self.present(alertCon, animated: true, completion: nil)
                        }
                    }
                        
                } else {
                    let alertCon = UIAlertController(title: "경고", message: "이메일과 비밀번호를 입력해 주십시오.", preferredStyle: UIAlertController.Style.alert)
                    let alertAct = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                    alertCon.addAction(alertAct)
                    self.present(alertCon, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    func setupLayout() {
        [
            imageView,
            titleLabel,
            emailStackView,
            passwdStackView,
            signinButton,
            buttonStackView
//            findEmailButton,
//            findPasswdButton,
//            signupButton
        ].forEach{ view.addSubview($0) }
        
        imageView.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(358)
            $0.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(90)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        emailLabel.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        
        emailStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(90)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(328)
            $0.height.equalTo(34)
        }
        
        passwdLabel.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        
        passwdStackView.snp.makeConstraints {
            $0.top.equalTo(emailStackView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(328)
            $0.height.equalTo(34)
        }
        
        signinButton.snp.makeConstraints {
            $0.top.equalTo(passwdStackView.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(34)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(signinButton.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(34)
        }
        
        findEmailButton.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(34)
        }

        findPasswdButton.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(34)
        }

        signupButton.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(34)
        }
    }
}
