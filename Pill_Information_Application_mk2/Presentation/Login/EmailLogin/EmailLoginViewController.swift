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
import Alamofire

final class EmailLoginViewController: UIViewController {
    
    let disposeBag = DisposeBag()
//    let db = Firestore.firestore()
    
    var keyboardCheck = true
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var dismissButton: UIBarButtonItem = {
        var barButtonItem = UIBarButtonItem(title: "취소".localized(), style: .plain, target: self, action: #selector(dismissButtonTapped))
//        var barButtonItem = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(dismissButtonTapped))
        barButtonItem.tintColor = .systemBlue
        return barButtonItem
    }()
    
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
        titleLabel.text = String(format: NSLocalizedString("이메일 로그인", comment: "Email Login"))
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 20.0, weight: .regular)
        titleLabel.textAlignment = .center
        
        return titleLabel
    }()
    
    private lazy var emailLabel: UILabel = {
        let emailLabel = UILabel()
        emailLabel.text = String(format: NSLocalizedString("이메일", comment: "Email"))
        emailLabel.textColor = .label
        emailLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        emailLabel.textAlignment = .center
        
        return emailLabel
    }()
    
    private lazy var emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.backgroundColor = .systemGray
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.delegate = self
        return emailTextField
    }()
    
    private lazy var passwdLabel: UILabel = {
        let passwdLabel = UILabel()
        passwdLabel.text = NSLocalizedString("비밀번호", comment: "Password")
        passwdLabel.textColor = .label
        passwdLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        passwdLabel.textAlignment = .center
        
        return passwdLabel
    }()
    
    private lazy var passwdTextField: UITextField = {
        let passwdTextField = UITextField()
        passwdTextField.backgroundColor = .systemGray
        passwdTextField.isSecureTextEntry = true
        passwdTextField.delegate = self
        return passwdTextField
    }()
    
    private lazy var signinButton: UIButton = {
        let signinButton = UIButton()
        signinButton.setTitle(NSLocalizedString("로그인", comment: "LogIn"), for: .normal)
        signinButton.setTitleColor(.systemBlue, for: .normal)
        signinButton.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        signinButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        return signinButton
    }()
    
    private lazy var findEmailButton: UIButton = {
        let findEmailButton = UIButton()
        findEmailButton.setTitle(NSLocalizedString("이메일 찾기", comment: "Find Email"), for: .normal)
        findEmailButton.setTitleColor(.systemBlue, for: .normal)
        findEmailButton.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        findEmailButton.addTarget(self, action: #selector(findEmailButtonTapped), for: .touchUpInside)
        return findEmailButton
    }()
    
    private lazy var findPasswdButton: UIButton = {
        let findPasswdButton = UIButton()
        findPasswdButton.setTitle(NSLocalizedString("비밀번호 찾기", comment: "Find Password"), for: .normal)
        findPasswdButton.setTitleColor(.systemBlue, for: .normal)
        findPasswdButton.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        findPasswdButton.addTarget(self, action: #selector(findPasswdButtonTapped), for: .touchUpInside)
        return findPasswdButton
    }()
    
    private lazy var signupButton: UIButton = {
        let signupButton = UIButton()
        signupButton.setTitle(NSLocalizedString("회원가입", comment: "SignUp"), for: .normal)
        signupButton.setTitleColor(.systemBlue, for: .normal)
        signupButton.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        signupButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
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
//            findEmailButton,
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
        self.title = NSLocalizedString("이메일 로그인", comment: "Email Login")
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
        self.navigationItem.leftBarButtonItem = dismissButton
        self.addKeyboardNotifications()
        bind()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
        self.removeKeyboardNotifications()
    }
}

extension EmailLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwdTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            signInButtonTapped()
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

private extension EmailLoginViewController {
    
    func bind() {
        
    }
    
    @objc func signInButtonTapped() {
        self.view.endEditing(true)
        if self.emailTextField.text != "" && self.passwdTextField.text != "" {
            
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwdTextField.text!) { (user, error) in
                
                if user != nil {
                    UserDefaults.standard.set("email", forKey: "loginType")
                    UserDefaults.standard.set(self.emailTextField.text!, forKey: "email")
                    UserDefaults.standard.set(self.passwdTextField.text!, forKey: "passwd")
                    
                    var userEmail = self.emailTextField.text!.replacingOccurrences(of: "@", with: "%40")
                    userEmail = userEmail.replacingOccurrences(of: ".", with: "%2E")
                    let url = "\(ubuntuServer.host + ubuntuServer.path)/getUserInfo/?email=\(String(describing: userEmail))"
                    print(url)
                    AF.request(url, method: .get)
                        .response(completionHandler: { [weak self] response in
                            guard let self = self else { return }
                            switch response.result {
                            case let .success(data):
                                do {
                                    let result = try JSONDecoder().decode(UserInfoOverview.self, from: data!)
                                    print(result)
                                    UserDefaults.standard.set(result.nickname!, forKey: "nickname")
                                } catch {
                                    print("failure: \(error)")
                                    let alertCon = UIAlertController(
                                        title: nil,
                                        message: NSLocalizedString("로그인에 실패했습니다", comment: "Failed Login"),
                                        preferredStyle: UIAlertController.Style.alert)
                                    let alertAct = UIAlertAction(
                                        title: NSLocalizedString("확인", comment: "Ok"),
                                        style: UIAlertAction.Style.destructive,
                                        handler: { _ in return }
                                    )
                                    alertCon.addAction(alertAct)
                                    self.present(alertCon, animated: true, completion: nil)
                                }
                                
                            case let .failure(error):
                                print("failure: \(error)")
                                let alertCon = UIAlertController(
                                    title: "Error",
                                    message: NSLocalizedString("로그인에 실패했습니다", comment: "Failed Login"),
                                    preferredStyle: UIAlertController.Style.alert)
                                let alertAct = UIAlertAction(
                                    title: NSLocalizedString("확인", comment: "Ok"),
                                    style: UIAlertAction.Style.destructive,
                                    handler: { _ in return }
                                )
                                alertCon.addAction(alertAct)
                                self.present(alertCon, animated: true, completion: nil)
                            }
                        })
                    
                    
//                    let userDB = self.db.collection("USER")
//                    let query = userDB.whereField("Email", isEqualTo: self.emailTextField.text!)
//                    query.getDocuments { (qs, err) in
//                        if qs!.documents.isEmpty {
//                            let alertCon = UIAlertController(title: "회원 정보가 없습니다.", message: nil, preferredStyle: UIAlertController.Style.alert)
//                            let alertAct = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
//                            alertCon.addAction(alertAct)
//                            self.present(alertCon, animated: true, completion: nil)
//                        } else {
//                            for document in qs!.documents {
//                                UserDefaults.standard.set(document.data()["NickName"]!, forKey: "nickname")
//                            }
//                        }
//                    }
                    
                    let vc = HomeTabBarController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                } else {
                    let alertCon = UIAlertController(title: NSLocalizedString("이메일과 비밀번호를 확인해 주십시오", comment: "Check Email and Password"), message: nil, preferredStyle: UIAlertController.Style.alert)
                    let alertAct = UIAlertAction(title: NSLocalizedString("확인", comment: "Ok"), style: UIAlertAction.Style.default)
                    alertCon.addAction(alertAct)
                    self.present(alertCon, animated: true, completion: nil)
                }
            }
                
        } else {
            let alertCon = UIAlertController(title: NSLocalizedString("이메일과 비밀번호를 입력해 주십시오", comment: "Check Email and Password"), message: nil, preferredStyle: UIAlertController.Style.alert)
            let alertAct = UIAlertAction(title: NSLocalizedString("확인", comment: "Ok"), style: UIAlertAction.Style.default)
            alertCon.addAction(alertAct)
            self.present(alertCon, animated: true, completion: nil)
        }
    }
    
    @objc func signUpButtonTapped() {
        self.view.endEditing(true)
        let vc = EmailSignUpViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func findEmailButtonTapped() {
        self.view.endEditing(true)
        let vc = FindEmailViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func findPasswdButtonTapped() {
        self.view.endEditing(true)
        let vc = FindPasswdViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func dismissButtonTapped() {
        self.view.endEditing(true)
        self.dismiss(animated: true)
    }
    
    
    func setupLayout() {
        [
            backgroundView,
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
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(358)
            $0.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        emailLabel.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        
        emailStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
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
    
    // 노티피케이션을 추가하는 메서드
    func addKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // 노티피케이션을 제거하는 메서드
    func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // 키보드가 나타났다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillShow(_ noti: NSNotification){
        // 키보드의 높이만큼 화면을 올려준다.
        if self.keyboardCheck {
            self.keyboardCheck = false
            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
//                self.view.frame.origin.y -= (keyboardHeight-(self.tabBarController?.tabBar.frame.size.height)!)
                self.view.frame.origin.y -= (keyboardHeight - 200)
            }
        }
    }

    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillHide(_ noti: NSNotification){
        self.keyboardCheck = true
        // 키보드의 높이만큼 화면을 내려준다.
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
//            self.view.frame.origin.y += (keyboardHeight-(self.tabBarController?.tabBar.frame.size.height)!)
            self.view.frame.origin.y += (keyboardHeight - 200)
        }
    }
}
