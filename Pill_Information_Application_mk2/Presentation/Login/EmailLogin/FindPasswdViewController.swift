//
//  FindPasswdViewController.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

import Firebase
import FirebaseAuth

final class FindPasswdViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let db = Firestore.firestore()
    let userDB = Firestore.firestore().collection("USER")
    
    var emailBool = false
    var keyboardCheck = true
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4.0
        imageView.image = UIImage(named: "sign_with")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 찾기"
        label.textColor = .label
        label.font = .systemFont(ofSize: 20.0, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray
        textField.delegate = self
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var warningEmailTypeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var findPasswdButton: UIButton = {
        let button = UIButton()
        button.setTitle("비밀번호 찾기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        return button
    }()
    
    
    private lazy var emailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            emailLabel,
            emailTextField
        ])
        stackView.axis = .horizontal
        stackView.spacing = 6.0
        stackView.distribution = .fill
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "비밀번호 찾기"
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
        bind()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
        self.removeKeyboardNotifications()
    }
}

extension FindPasswdViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

private extension FindPasswdViewController {
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
        
        findPasswdButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                if self.emailBool {
                    Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!) { (error) in
                        if error != nil {
                            let alertCon = UIAlertController(title: "경고", message: "이메일이 존재하지 않습니다.", preferredStyle: UIAlertController.Style.alert)
                            let alertAct = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                            alertCon.addAction(alertAct)
                            self.present(alertCon, animated: true, completion: nil)
                        } else {
                            let alertCon = UIAlertController(title: "확인", message: "비밀번호 재설정 이메일을 전송했습니다.", preferredStyle: UIAlertController.Style.alert)
                            let alertAct = UIAlertAction(
                                title: "확인",
                                style: UIAlertAction.Style.default,
                                handler: { _ in self.dismiss(animated: true) }
                            )
                            alertCon.addAction(alertAct)
                            self.present(alertCon, animated: true, completion: nil)
                        }
                    }
                } else {
                    let alertCon = UIAlertController(title: "경고", message: "이메일 형식을 맞춰주세요.", preferredStyle: UIAlertController.Style.alert)
                    let alertAct = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                    alertCon.addAction(alertAct)
                    self.present(alertCon, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)

    }
    
    func setupLayout() {
        [
            backgroundView,
            imageView,
            titleLabel,
            emailStackView,
            findPasswdButton
        ].forEach{ view.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
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
        
        emailLabel.snp.makeConstraints {
            $0.width.equalTo(100)
        }

        emailStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(90)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(320)
            $0.height.equalTo(34)
        }

        findPasswdButton.snp.makeConstraints {
            $0.top.equalTo(emailStackView.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
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
    //            self.view.frame.origin.y -= (keyboardHeight-(self.tabBarController?.tabBar.frame.size.height)!)
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
