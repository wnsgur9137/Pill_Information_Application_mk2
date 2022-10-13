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

final class EmailSignUpViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 7.0
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.separator.cgColor
        imageView.backgroundColor = .systemBlue
        
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
        
        
        return emailTextField
    }()
    
    private lazy var warningEmailTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일 형식에 맞추어 주십시오."
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
        label.textAlignment = .right
        
        return label
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
        
        return passwdTextField
    }()
    
    private lazy var warningPasswdTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "소문자, 대문자, 숫자를 조합하여\n 8자 이상 입력해 주십시오."
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
        label.textAlignment = .right
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var passwdCheckLabel: UILabel = {
        let passwdCheckLabel = UILabel()
        passwdCheckLabel.text = "Password"
        passwdCheckLabel.textColor = .label
        passwdCheckLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        passwdCheckLabel.textAlignment = .center
        
        return passwdCheckLabel
    }()
    
    private lazy var passwdCheckTextField: UITextField = {
        let passwdCheckTextField = UITextField()
        passwdCheckTextField.backgroundColor = .systemGray
        
        return passwdCheckTextField
    }()
    
    private lazy var warningPasswdCheckLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호가 일치하지 않습니다."
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("SignUp", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        
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
        stackView.spacing = 6.0
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
        stackView.spacing = 6.0
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
        stackView.spacing = 6.0
        stackView.distribution = .fill
        
        return stackView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SignUp"
        
        bind()
        setupLayout()
    }
}

private extension EmailSignUpViewController {
    func bind() {
        
    }
    
    func setupLayout() {
        [
            imageView,
            titleLabel,
            emailVerticalStackView,
            passwdVerticalStackView,
            passwdCheckVerticalStackView,
            signupButton
        ].forEach { view.addSubview($0) }
        
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
        
        emailVerticalStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(90)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(328)
            $0.height.equalTo(34)
        }
        
        passwdLabel.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        
        passwdVerticalStackView.snp.makeConstraints {
            $0.top.equalTo(emailVerticalStackView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(328)
            $0.height.equalTo(34)
        }
        
        passwdCheckLabel.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        
        passwdCheckVerticalStackView.snp.makeConstraints {
            $0.top.equalTo(passwdVerticalStackView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(328)
            $0.height.equalTo(34)
        }
        
        signupButton.snp.makeConstraints {
            $0.top.equalTo(passwdCheckVerticalStackView.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
        }
    }
}
