//
//  ProfileUpdateViewController.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProfileUpdateViewController: UIViewController {
    
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile Update"
        label.textColor = .label
        label.font = .systemFont(ofSize: 20.0, weight: .regular)
        return label
    }()
    
    private lazy var myInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "내 정보"
        label.textColor = .label
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        return label
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임: "
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private lazy var nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = UserDefaults.standard.string(forKey: "nickname")
        textField.backgroundColor = .systemGray
        return textField
    }()
    
    private lazy var warningChangeNicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임은 한 달에 한 번 변경할 수 있습니다."
        label.textColor = .label
        label.font = .systemFont(ofSize: 10.0, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var changeNicknameButton: UIButton = {
        let button = UIButton()
        button.setTitle("닉네임 변경", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .bold)
        button.addTarget(self, action: #selector(changeNicknameButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일: "
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = UserDefaults.standard.string(forKey: "email")
        return textField
    }()
    
    private lazy var passwdChangeLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 변경"
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var nowPasswdLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 비밀번호: "
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var newPasswdLabel: UILabel = {
        let label = UILabel()
        label.text = "새 비밀번호: "
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var newPasswdCheckLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 확인: "
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var nowPasswdTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray
        textField.isSecureTextEntry = true
        textField.delegate = self
        return textField
    }()
    
    private lazy var newPasswdTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray
        textField.isSecureTextEntry = true
        textField.delegate = self
        return textField
    }()
    
    private lazy var newPasswdCheckTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray
        textField.isSecureTextEntry = true
        textField.delegate = self
        return textField
    }()
    
    private lazy var warningChangePasswdLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        return label
    }()
    
    private lazy var changePasswdButton: UIButton = {
        let button = UIButton()
        button.setTitle("비밀번호 변경", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .bold)
        button.addTarget(self, action: #selector(changePasswdButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var withdrawLabel: UILabel = {
        let label = UILabel()
        label.text = "회원 탈퇴"
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        return label
    }()
    
    private lazy var warningWithdrawLabel: UILabel = {
        let label = UILabel()
        label.text = "회원 탈퇴시, 복구할 수 없습니다."
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        return label
    }()
    
    private lazy var withdrawPasswdCheckLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 비밀번호: "
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var withdrawPasswdCheckTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray
        textField.isSecureTextEntry = true
        textField.delegate = self
        return textField
    }()
    
    private lazy var withdrawButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원 탈퇴", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .bold)
        button.addTarget(self, action: #selector(withdrawButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var userInfoStackView: UIStackView = {
        let nicknameFieldStackView = UIStackView(arrangedSubviews: [
            nicknameLabel,
            nicknameTextField,
            changeNicknameButton
        ])
        nicknameFieldStackView.axis = .horizontal
        nicknameFieldStackView.distribution = .fill
        nicknameFieldStackView.spacing = 20.0
        
        let nicknameStackView = UIStackView(arrangedSubviews: [
            nicknameFieldStackView,
            warningChangeNicknameLabel
        ])
        nicknameStackView.axis = .vertical
        nicknameStackView.distribution = .fill
        nicknameStackView.spacing = 5.0
        
        
        let emailStackView = UIStackView(arrangedSubviews: [
            emailLabel,
            emailTextField
        ])
        emailStackView.axis = .horizontal
        emailStackView.distribution = .fill
        emailStackView.spacing = 20.0
        
        let stackView = UIStackView(arrangedSubviews: [
            nicknameStackView,
            emailStackView
        ])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 15.0
        return stackView
    }()
    
    
    private lazy var changePasswdStackView: UIStackView = {
        let nowPasswdStackView = UIStackView(arrangedSubviews: [
            nowPasswdLabel,
            nowPasswdTextField
        ])
        nowPasswdStackView.axis = .horizontal
        nowPasswdStackView.distribution = .fill
        nowPasswdStackView.spacing = 20.0
        
        let newPasswdStackView = UIStackView(arrangedSubviews: [
            newPasswdLabel,
            newPasswdTextField
        ])
        newPasswdStackView.axis = .horizontal
        newPasswdStackView.distribution = .fill
        newPasswdStackView.spacing = 20.0
        
        let newPasswdCheckStackView = UIStackView(arrangedSubviews: [
            newPasswdCheckLabel,
            newPasswdCheckTextField
        ])
        newPasswdCheckStackView.axis = .horizontal
        newPasswdCheckStackView.distribution = .fill
        newPasswdCheckStackView.spacing = 20.0
        
        
        let stackView = UIStackView(arrangedSubviews: [
            nowPasswdStackView,
//            newPasswdStackView,
//            newPasswdCheckStackView,
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 15.0
        return stackView
    }()
    
    private lazy var withdrawPasswdStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            withdrawPasswdCheckLabel,
            withdrawPasswdCheckTextField
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 20.0
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "내 정보 변경"
        
        bind()
        setupLayout()
    }
}

extension ProfileUpdateViewController: UITextFieldDelegate {
    
}

private extension ProfileUpdateViewController {
    func bind() {
        
    }
    
    @objc func changeNicknameButtonTapped() {
        
    }
    
    @objc func changePasswdButtonTapped() {
        
    }
    
    @objc func withdrawButtonTapped() {
        
    }
    
    func setupLayout() {
        [
            backgroundView,
            titleLabel,
            myInfoLabel,
            userInfoStackView,
            passwdChangeLabel,
            changePasswdStackView,
            warningChangePasswdLabel,
            changePasswdButton,
            withdrawLabel,
            warningWithdrawLabel,
            withdrawPasswdStackView,
            withdrawButton
        ].forEach{ view.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        myInfoLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(40)
            $0.height.equalTo(34)
        }
        
        userInfoStackView.snp.makeConstraints {
            $0.top.equalTo(myInfoLabel.snp.bottom).offset(10)
            $0.leading.equalTo(myInfoLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(40)
            [nicknameLabel, emailLabel].forEach{ $0.snp.makeConstraints {
                $0.width.equalTo(50)
                $0.height.equalTo(34)
            }}
            changeNicknameButton.snp.makeConstraints {
                $0.width.equalTo(80)
            }
        }
        
        passwdChangeLabel.snp.makeConstraints {
            $0.top.equalTo(userInfoStackView.snp.bottom).offset(40)
            $0.leading.equalTo(myInfoLabel.snp.leading)
            $0.height.equalTo(34)
            
            [
                nowPasswdLabel,
                newPasswdLabel,
                newPasswdCheckLabel
            ].forEach { $0.snp.makeConstraints {
                $0.width.equalTo(100)
            }}
        }
        
        changePasswdStackView.snp.makeConstraints {
            $0.top.equalTo(passwdChangeLabel.snp.bottom).offset(10)
            $0.leading.equalTo(myInfoLabel.snp.leading)
            $0.trailing.equalTo(userInfoStackView.snp.trailing)
            $0.height.equalTo(34)
        }
        
        warningChangePasswdLabel.snp.makeConstraints {
            $0.top.equalTo(changePasswdStackView.snp.bottom).offset(10)
            $0.leading.equalTo(myInfoLabel.snp.leading)
            $0.height.equalTo(34)
        }
        
        changePasswdButton.snp.makeConstraints {
            $0.top.equalTo(changePasswdStackView.snp.bottom).offset(10)
            $0.trailing.equalTo(changePasswdStackView.snp.trailing)
        }
        
        withdrawLabel.snp.makeConstraints {
            $0.top.equalTo(changePasswdButton.snp.bottom).offset(20)
            $0.leading.equalTo(myInfoLabel.snp.leading)
            $0.height.equalTo(34)
        }
        
        warningWithdrawLabel.snp.makeConstraints {
            $0.top.equalTo(withdrawLabel.snp.bottom).offset(10)
            $0.leading.equalTo(myInfoLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(40)
        }
        
        withdrawPasswdStackView.snp.makeConstraints {
            $0.top.equalTo(warningWithdrawLabel.snp.bottom).offset(10)
            $0.leading.equalTo(myInfoLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(34)
            withdrawPasswdCheckLabel.snp.makeConstraints {
                $0.width.equalTo(100)
            }
        }
        
        withdrawButton.snp.makeConstraints {
            $0.top.equalTo(withdrawPasswdStackView.snp.bottom).offset(10)
            $0.trailing.equalTo(warningWithdrawLabel.snp.trailing)
        }
        
    }
}
