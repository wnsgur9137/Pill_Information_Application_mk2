//
//  EmailSignUpView.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Alamofire

import Firebase
import FirebaseAuth
//import FirebaseFirestore

final class EmailSignUpViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var emailBool = false
    var pwdTypeBool = false
    var pwdCheckBool = false
    
    var keyboardCheck = true
    
//    let db = Firestore.firestore()
    
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 7.0
//        imageView.layer.borderWidth = 0.5
//        imageView.layer.borderColor = UIColor.separator.cgColor
        imageView.image = UIImage(named: "sign_with")
        imageView.contentMode = .scaleAspectFit
//        imageView.backgroundColor = .systemBlue
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Email 회원가입"
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 20.0, weight: .regular)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    private lazy var emailLabel: UILabel = {
        let emailLabel = UILabel()
        emailLabel.text = "이메일"
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
    
    private lazy var warningEmailTypeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var passwdLabel: UILabel = {
        let passwdLabel = UILabel()
        passwdLabel.text = "비밀번호"
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
    
    private lazy var warningPasswdTypeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
        label.textAlignment = .right
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var passwdCheckLabel: UILabel = {
        let passwdCheckLabel = UILabel()
        passwdCheckLabel.text = "비밀번호 확인"
        passwdCheckLabel.textColor = .label
        passwdCheckLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        passwdCheckLabel.textAlignment = .center
        
        return passwdCheckLabel
    }()
    
    private lazy var passwdCheckTextField: UITextField = {
        let passwdCheckTextField = UITextField()
        passwdCheckTextField.backgroundColor = .systemGray
        passwdCheckTextField.isSecureTextEntry = true
        passwdCheckTextField.delegate = self
        return passwdCheckTextField
    }()
    
    private lazy var warningPasswdCheckLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        button.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var emailHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            emailLabel,
            emailTextField
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 6.0
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var emailVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            emailHorizontalStackView,
            warningEmailTypeLabel
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 1.0
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var passwdHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            passwdLabel,
            passwdTextField
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 6.0
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var passwdVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            passwdHorizontalStackView,
            warningPasswdTypeLabel
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 1.0
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var passwdCheckHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            passwdCheckLabel,
            passwdCheckTextField
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 6.0
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var passwdCheckVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            passwdCheckHorizontalStackView,
            warningPasswdCheckLabel
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 1.0
        stackView.distribution = .fill
        
        return stackView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "회원가입"
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
        bind()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications()
    }
}

extension EmailSignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwdTextField.becomeFirstResponder()
        } else if textField == self.passwdTextField {
            self.passwdCheckTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            signupButtonTapped()
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

private extension EmailSignUpViewController {
    func bind() {
        
        emailTextField.rx.text
            .subscribe(onNext: { [weak self] changeText in
                guard let self = self else { return }
                if changeText != "" {
                    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
                    if !NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: changeText) {
                        self.warningEmailTypeLabel.text = "이메일 형식에 맞추어 주십시오."
                        self.emailBool = false
                    } else {
                        self.warningEmailTypeLabel.text = ""
                        self.emailBool = true
                    }
                }
            })
            .disposed(by: disposeBag)
        
        passwdTextField.rx.text
            .subscribe(onNext: { [weak self] changeText in
                guard let self = self else { return }
                if changeText != "" {
                    let passwordreg =  ("(?=.*[A-Za-z])(?=.*[0-9]).{8,20}")
                    if !NSPredicate(format: "SELF MATCHES %@", passwordreg).evaluate(with: changeText) {
                        self.warningPasswdTypeLabel.text = """
                                                            문자, 숫자, 특수문자르 조합하여
                                                            8~20 길이의 형식을 맞추어 주십시오.
                                                            """
                        self.pwdTypeBool = false
                    } else {
                        self.warningPasswdTypeLabel.text = ""
                        self.pwdTypeBool = true
                    }
                }
            })
            .disposed(by: disposeBag)
        
        passwdCheckTextField.rx.text
            .subscribe(onNext: { [weak self] changeText in
                guard let self = self else { return }
                if changeText != self.passwdTextField.text {
                    self.warningPasswdCheckLabel.text = "비밀번호가 일치하지 않습니다."
                    self.pwdCheckBool = false
                } else {
                    self.warningPasswdCheckLabel.text = ""
                    self.pwdCheckBool = true
                }
            })
            .disposed(by: disposeBag)

    }
    
    @objc func signupButtonTapped() {
        if self.emailBool && self.pwdCheckBool && self.pwdCheckBool {
            
            let urlEmail = emailTextField.text ?? ""
            
            let param = "?email=\(urlEmail)"
            
//            let url = "\(FastAPI.host + FastAPI.path)/getUserInfo/\(param)"
            let url = "\(ubuntuServer.host + ubuntuServer.path)/getUserInfo/\(param)"
            
            AF.request(url, method: .get)
                .response(completionHandler: { [weak self] response in
                    guard let self = self else { return }
                    switch response.result {
                    case let .success(data):
                        print("success: \(String(describing: data))")
                        do {
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(UserInfoOverview.self, from: data!)
                            if result.nickname == "" {
                                // 사용 가능한 이메일일 경우
                                
                                let vc = NicknameSetViewController()
                                vc.email = self.emailTextField.text!
                                vc.passwd = self.passwdTextField.text!
                                self.navigationController?.pushViewController(vc, animated: true)
                            } else {
                                let alertCon = UIAlertController(title: "경고", message: "중복된 이메일입니다.", preferredStyle: UIAlertController.Style.alert)
                                let alertAct = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                                alertCon.addAction(alertAct)
                                self.present(alertCon, animated: true, completion: nil)
                            }
                        } catch {
                            print("catch")
                            let alertCon = UIAlertController(title: "경고", message: "중복된 이메일입니다.", preferredStyle: UIAlertController.Style.alert)
                            let alertAct = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                            alertCon.addAction(alertAct)
                            self.present(alertCon, animated: true, completion: nil)
                        }
                    case let .failure(error):
                        print("error: \(error)")
                    }
                })
            
            
            // FirebaseStore 사용할 시 (현재 사용하지 않음)
            // 이메일 중복체크
//            let userDB = self.db.collection("USER")
//            let query = userDB.whereField("Email", isEqualTo: self.emailTextField.text!)
//            query.getDocuments { (qs, err) in
//                if qs!.documents.isEmpty {
//                    // 사용 가능한 이메일일 경우
//                    let vc = NicknameSetViewController()
//                    vc.email = self.emailTextField.text!
//                    vc.passwd = self.passwdTextField.text!
//                    self.navigationController?.pushViewController(vc, animated: true)
//                } else {
//                    // 이메일이 중복된 경우
//                    let alertCon = UIAlertController(title: "경고", message: "중복된 이메일입니다.", preferredStyle: UIAlertController.Style.alert)
//                    let alertAct = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
//                    alertCon.addAction(alertAct)
//                    self.present(alertCon, animated: true, completion: nil)
//                }
//            }
        } else {
            let alertCon = UIAlertController(title: "경고", message: "이메일과 비밀번호를 확인해 주십시오.", preferredStyle: UIAlertController.Style.alert)
            let alertAct = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
            alertCon.addAction(alertAct)
            self.present(alertCon, animated: true, completion: nil)
        }
    }
    
    func setupLayout() {
        [
            backgroundView,
            imageView,
            titleLabel,
            emailVerticalStackView,
            passwdVerticalStackView,
            passwdCheckVerticalStackView,
            signupButton
        ].forEach { view.addSubview($0) }
        
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
        
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(32)
        }
        
        emailVerticalStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(328)
            $0.height.equalTo(64)
        }
        
        passwdLabel.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        
        passwdTextField.snp.makeConstraints {
            $0.height.equalTo(32)
        }
        
        passwdVerticalStackView.snp.makeConstraints {
            $0.top.equalTo(emailVerticalStackView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(328)
            $0.height.equalTo(90)
        }
        
        passwdCheckLabel.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        
        passwdCheckTextField.snp.makeConstraints {
            $0.height.equalTo(32)
        }
        
        passwdCheckVerticalStackView.snp.makeConstraints {
            $0.top.equalTo(passwdVerticalStackView.snp.bottom).offset(1)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(328)
            $0.height.equalTo(64)
        }
        
        signupButton.snp.makeConstraints {
            $0.top.equalTo(passwdCheckVerticalStackView.snp.bottom).offset(80)
            $0.centerX.equalToSuperview()
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
                self.view.frame.origin.y -= keyboardHeight
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
            self.view.frame.origin.y += keyboardHeight
        }
    }
}
