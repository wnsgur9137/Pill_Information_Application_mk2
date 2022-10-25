//
//  FindEmailResultView.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/25.
//

import UIKit
import SnapKit

final class FindEmailResultView: UIViewController {
    
    var email: String! = nil
    
    
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
        label.text = "이메일 찾기"
        label.textColor = .label
        label.font = .systemFont(ofSize: 20.0, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "test@test.com 입니다."
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var gotoEmailLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인 하기", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        button.addTarget(self, action: #selector(gotoEmailLoginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var gotoFindPasswdButton: UIButton = {
        let button = UIButton()
        button.setTitle("비밀번호 찾기", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        button.addTarget(self, action: #selector(gotoFindPasswdButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            gotoEmailLoginButton,
            gotoFindPasswdButton
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 20.0
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "이메일 찾기"
        setupLayout()
        setupLayoutInfo()
    }
}

private extension FindEmailResultView {
    
    @objc func gotoEmailLoginButtonTapped() {
        let controllers = self.navigationController?.viewControllers
        for vc in controllers! {
            if vc is EmailLoginViewController {
                _ = self.navigationController?.popToViewController(vc as! EmailLoginViewController, animated: true)
            }
        }
    }
    
    @objc func gotoFindPasswdButtonTapped() {
        let controllers = self.navigationController?.viewControllers
        for vc in controllers! {
            if vc is EmailLoginViewController {
                _ = self.navigationController?.popToViewController(vc as! EmailLoginViewController, animated: true)
                self.navigationController?.pushViewController(FindPasswdView(), animated: true)
            }
        }
    }
    
    func setupLayoutInfo() {
        self.emailLabel.text = "해당 닉네임의 이메일은\n\(String(describing: email!)) 입니다."
    }
    
    func setupLayout() {
        [
            backgroundView,
            imageView,
            titleLabel,
            emailLabel,
            buttonStackView
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
            $0.top.equalTo(titleLabel.snp.bottom).offset(90)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(320)
//            $0.height.equalTo(102)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(100.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(34)
        }
    }
}
