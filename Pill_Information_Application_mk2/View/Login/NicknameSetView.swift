//
//  NicknameSetView.swift
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
import FirebaseFirestore

final class NicknameSetView: UIViewController {
    
    let db = Firestore.firestore()
    
    let disposeBag = DisposeBag()
    var email: String? = ""
    var passwd: String? = ""
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "사용할 닉네임을 입력해주세요."
        
        return label
    }()
    
    private lazy var nicknameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "닉네임을 입력해 주세요"
        
        return textfield
    }()
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("SignUp", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        setupLayout()
    }
}

private extension NicknameSetView {
    func bind() {
        signUpButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                // 유저 생성
                
                // 이메일 중복체크
                let userDB = self.db.collection("USER")
                let query = userDB.whereField("NickName", isEqualTo: self.nicknameTextField.text!)
                query.getDocuments { (qs, err) in
                    if qs!.documents.isEmpty {
                        Auth.auth().createUser(withEmail: self.email!, password: self.passwd!) {
                            [self]authResult, error in
                            if let _ = error {  // 유저 생성에 실패할 경우
                                let alertCon = UIAlertController(title: "경고", message: "중복된 이메일입니다.", preferredStyle: UIAlertController.Style.alert)
                                let alertAct = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                                alertCon.addAction(alertAct)
                                self.present(alertCon, animated: true, completion: nil)
                            } else {    // 유저 생성에 성공할 경우
                                
                                // Firestore에 데이터 생성
                                self.db.collection("USER").document(self.nicknameTextField.text!).setData([
                                    "Email": self.email!,
                                    "NickName": self.nicknameTextField.text!
                                ])
                                
                                // 회원가입시 자동 로그인
                                Auth.auth().signIn(withEmail: self.email!, password: self.passwd!) { (user, error) in
                                    
                                    if user != nil {
                                        UserDefaults.standard.set("email", forKey: "loginType")
                                        UserDefaults.standard.set(self.email!, forKey: "email")
                                        UserDefaults.standard.set(self.passwd!, forKey: "passwd")
                                        UserDefaults.standard.set(self.nicknameTextField.text!, forKey: "nickname")
                                        
                                        let alertCon = UIAlertController(title: "성공", message: "환영합니다.", preferredStyle: UIAlertController.Style.alert)
                                        let alertAct = UIAlertAction(title: "로그인", style: UIAlertAction.Style.default, handler: { _ in
                                            let vc = HomeTabBarController()
                                            vc.modalPresentationStyle = .fullScreen
                                            self.present(vc, animated: true)
                                        })
                                        alertCon.addAction(alertAct)
                                        self.present(alertCon, animated: true, completion: nil)
                                    } else {
                                        let alertCon = UIAlertController(title: "경고", message: "이메일과 비밀번호를 확인해 주십시오.", preferredStyle: UIAlertController.Style.alert)
                                        let alertAct = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                                        alertCon.addAction(alertAct)
                                        self.present(alertCon, animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                    } else {
                        // 이메일이 중복된 경우
                        let alertCon = UIAlertController(title: "경고", message: "중복된 닉네임입니다.", preferredStyle: UIAlertController.Style.alert)
                        let alertAct = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                        alertCon.addAction(alertAct)
                        self.present(alertCon, animated: true, completion: nil)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setupLayout() {
        [
            titleLabel,
            nicknameTextField,
            warningLabel,
            signUpButton
        ].forEach { view.addSubview($0) }
        
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
            $0.trailing.equalTo(nicknameTextField.snp.trailing)
            $0.height.equalTo(34)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
        }
    }
}
