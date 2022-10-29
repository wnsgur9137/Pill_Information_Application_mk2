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

final class FindPasswdViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let db = Firestore.firestore()
    let userDB = Firestore.firestore().collection("USER")
    
    var emailBool = false
    
    
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
        button.setTitleColor(.label, for: .normal)
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
        bind()
        setupLayout()
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
}
