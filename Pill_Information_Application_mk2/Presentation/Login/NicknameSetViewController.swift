//
//  NicknameSetViewController.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Alamofire

import Firebase
import FirebaseAuth
//import FirebaseFirestore

final class NicknameSetViewController: UIViewController {
    
    let disposeBag = DisposeBag()
//    let db = Firestore.firestore()
    var email: String? = ""
    var passwd: String? = ""
    var nickNameBool: Bool = false
    
    var keyboardCheck = true
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "사용할 닉네임을 입력해주세요".localized()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var nicknameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "닉네임을 입력해 주세요".localized()
        textfield.delegate = self
        textfield.autocapitalizationType = .none
        return textfield
    }()
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입".localized(), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
        bind()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.addKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
//        self.removeKeyboardNotifications()
    }
}

extension NicknameSetViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        signUpButtonTapped()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

private extension NicknameSetViewController {
    
    func bind() {
        nicknameTextField.rx.text
            .bind(onNext: { [weak self] changeText in
                guard let self = self else { return }
                if changeText != "" {
                    print(String(changeText!).count)
                    if String(changeText!).count >= 2 && String(changeText!).count <= 8 {
                        self.warningLabel.text = ""
                        self.nickNameBool = true
                    } else {
                        self.nickNameBool = false
                        self.warningLabel.text = "닉네임은 2자 이상, 8자 이하로 설정해주세요.".localized()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc func signUpButtonTapped() {
        self.view.endEditing(true)
        // 유저 생성
        if !nickNameBool {
            let alertCon = UIAlertController(title: "닉네임은 2자 이상, 8자 이하로 설정해주세요.".localized(), message: nil, preferredStyle: UIAlertController.Style.alert)
            let alertAct = UIAlertAction(title: "확인".localized(), style: UIAlertAction.Style.default)
            alertCon.addAction(alertAct)
            present(alertCon, animated: true)
            return
        }
        
        let nicknameCheckparam = "nickname=\(nicknameTextField.text ?? "")".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        let nicknameCheckurl = "\(FastAPI.host + FastAPI.path)/getNicknameCheck/\(nicknameCheckparam)"
        let nicknameCheckurl = "\(ubuntuServer.host + ubuntuServer.path)/getNicknameCheck/?\(String(describing: nicknameCheckparam!))"
        
        AF.request(nicknameCheckurl, method: .get)
            .response(completionHandler: { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case let .success(data):
                    print("success: \(String(describing: data))")
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(UserInfoOverview.self, from: data!)
                        if self.nicknameTextField.text ?? "" == result.nickname {
                            let alertCon = UIAlertController(title: "중복된 닉네임입니다.".localized(), message: nil, preferredStyle: UIAlertController.Style.alert)
                            let alertAct = UIAlertAction(title: "확인".localized(), style: UIAlertAction.Style.default)
                            alertCon.addAction(alertAct)
                            self.present(alertCon, animated: true, completion: nil)
                        } else {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let current_date_string = formatter.string(from: Date())
                            
                            var urlEmail = self.email?.replacingOccurrences(of: "@", with: "%40")
                            urlEmail = urlEmail?.replacingOccurrences(of: ".", with: "%2E")
                            
                            var urlTime = current_date_string.replacingOccurrences(of: "-", with: "%2D")
                            urlTime = urlTime.replacingOccurrences(of: " ", with: "%20")
                            urlTime = urlTime.replacingOccurrences(of: ":", with: "%3A")
                            
                            let nickname = self.nicknameTextField.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                            
                            let param = "?email=\(urlEmail!)&nickname=\(nickname!)&updateDate=\(urlTime)"
                            
//                            let url = "\(FastAPI.host + FastAPI.path)/setUserInfo/\(param)"
                            let url = "\(ubuntuServer.host + ubuntuServer.path)/setUserInfo/\(param)"
                            
                            AF.request(url, method: .post, encoding: URLEncoding.httpBody)
                                .response(completionHandler: { response in
                                    switch response.result {
                                    case let .success(data):
                                        print("success: \(String(describing: data))")
                                    case let .failure(error):
                                        print("failure: \(error)")
                                    }
                                })
                            
                            print(url)
                            print("param: \(param)")
                            
                            Auth.auth().createUser(withEmail: self.email!, password: self.passwd!) {
                                [self]authResult, error in
                                if let _ = error {  // 유저 생성에 실패할 경우
                                    let alertCon = UIAlertController(title: "중복된 이메일입니다.".localized(), message: nil, preferredStyle: UIAlertController.Style.alert)
                                    let alertAct = UIAlertAction(title: "확인".localized(), style: UIAlertAction.Style.default)
                                    alertCon.addAction(alertAct)
                                    self.present(alertCon, animated: true, completion: nil)
                                } else {    // 유저 생성에 성공할 경우
                                    // Firestore에 데이터 생성
                    //                self.db.collection("USER").document(self.nicknameTextField.text!).setData([
                    //                    "Email": self.email!,
                    //                    "NickName": self.nicknameTextField.text!
                    //                ])
                                    // 회원가입시 자동 로그인
                                    self.autoLogin()
                                }
                            }
                        }
                    } catch {
                        let alertCon = UIAlertController(title: "중복된 닉네임입니다.".localized(), message: nil, preferredStyle: UIAlertController.Style.alert)
                        let alertAct = UIAlertAction(title: "확인".localized(), style: UIAlertAction.Style.default)
                        alertCon.addAction(alertAct)
                        self.present(alertCon, animated: true, completion: nil)
                    }
                case let .failure(error):
                    print("error: \(error)")
                }
            })
        
        
//        // 이메일 중복체크 (FirebaseStorege를 사용할 경우 현재 미사용)
//        let userDB = self.db.collection("USER")
//        let query = userDB.whereField("NickName", isEqualTo: self.nicknameTextField.text!)
//        query.getDocuments { (qs, err) in
//            if qs!.documents.isEmpty {
//                Auth.auth().createUser(withEmail: self.email!, password: self.passwd!) {
//                    [self]authResult, error in
//                    if let _ = error {  // 유저 생성에 실패할 경우
//                        let alertCon = UIAlertController(title: "중복된 이메일입니다.", message: nil, preferredStyle: UIAlertController.Style.alert)
//                        let alertAct = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
//                        alertCon.addAction(alertAct)
//                        self.present(alertCon, animated: true, completion: nil)
//                    } else {    // 유저 생성에 성공할 경우
//
//                        // Firestore에 데이터 생성
//                        self.db.collection("USER").document(self.nicknameTextField.text!).setData([
//                            "Email": self.email!,
//                            "NickName": self.nicknameTextField.text!
//                        ])
//                        // 회원가입시 자동 로그인
//                        autoLogin()
//                    }
//                }
//            } else {
//                // 이메일이 중복된 경우
//                let alertCon = UIAlertController(title: "중복된 닉네임입니다.", message: nil, preferredStyle: UIAlertController.Style.alert)
//                let alertAct = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
//                alertCon.addAction(alertAct)
//                self.present(alertCon, animated: true, completion: nil)
//            }
//        }
        
    }
    
    func autoLogin() {
        // 회원가입시 자동 로그인
        Auth.auth().signIn(withEmail: self.email!, password: self.passwd!) { (user, error) in
            
            if user != nil {
                UserDefaults.standard.set("email", forKey: "loginType")
                UserDefaults.standard.set(self.email!, forKey: "email")
                UserDefaults.standard.set(self.passwd!, forKey: "passwd")
                UserDefaults.standard.set(self.nicknameTextField.text!, forKey: "nickname")
                
                let alertCon = UIAlertController(title: nil, message: "환영합니다.".localized(), preferredStyle: UIAlertController.Style.alert)
                let alertAct = UIAlertAction(title: "로그인".localized(), style: UIAlertAction.Style.default, handler: { _ in
                    let vc = MainTabBarController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                })
                alertCon.addAction(alertAct)
                self.present(alertCon, animated: true, completion: nil)
            } else {
                let alertCon = UIAlertController(title: "이메일과 비밀번호를 확인해 주십시오.".localized(), message: nil, preferredStyle: UIAlertController.Style.alert)
                let alertAct = UIAlertAction(title: "확인".localized(), style: UIAlertAction.Style.default)
                alertCon.addAction(alertAct)
                self.present(alertCon, animated: true, completion: nil)
            }
        }
    }
    
    func setupLayout() {
        [
            backgroundView,
            titleLabel,
            nicknameTextField,
            warningLabel,
            signUpButton
        ].forEach { view.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            $0.leading.equalToSuperview().offset(20)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.width.equalTo(300)
            $0.height.equalTo(34)
        }
        
        warningLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(10)
            $0.leading.equalTo(nicknameTextField.snp.leading)
            $0.height.equalTo(34)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(100)
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
