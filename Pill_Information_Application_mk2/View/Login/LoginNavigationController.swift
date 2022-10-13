//
//  LoginNavigationController.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/13.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    
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
        titleLabel.text = "로그인 방법을 선택해 주세요!"
        titleLabel.font = .systemFont(ofSize: 24.0, weight: .bold)
        titleLabel.textColor = .systemMint
        
        return titleLabel
    }()
    
    private lazy var appleImageButton: UIButton = {
        let appleImage = UIButton()
        appleImage.setImage(systemName: "applelogo")
        
        return appleImage
    }()
    
    private lazy var appleImage: UIImageView = {
        let appleImage = UIImageView()
        appleImage.image = UIImage(systemName: "applelogo")
        appleImage.contentMode = .scaleAspectFit

        return appleImage
    }()
    
    private lazy var appleButton: UIButton = {
        let appleButton = UIButton()
        appleButton.setTitle("Apple Login", for: .normal)
        appleButton.setTitleColor(.label, for: .normal)
        appleButton.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .semibold)
        appleButton.backgroundColor = .systemBackground
        appleButton.layer.cornerRadius = 3.0
        
        return appleButton
    }()
    
    private lazy var kakaoImage: UIImageView = {
        let kakaoImage = UIImageView()
        kakaoImage.image = UIImage(systemName: "applelogo")
        kakaoImage.contentMode = .scaleAspectFit

        return kakaoImage
    }()
    
    private lazy var kakaoButton: UIButton = {
        let kakaoButton = UIButton()
        kakaoButton.setTitle("Kakao Login", for: .normal)
        kakaoButton.setTitleColor(.label, for: .normal)
        kakaoButton.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .semibold)
        kakaoButton.backgroundColor = .systemBackground
        kakaoButton.layer.cornerRadius = 3.0
        
        return kakaoButton
    }()
    
    private lazy var googleImage: UIImageView = {
        let googleImage = UIImageView()
        googleImage.image = UIImage(systemName: "applelogo")
        googleImage.contentMode = .scaleAspectFit

        return googleImage
    }()
    
    private lazy var googleButton: UIButton = {
        let googleButton = UIButton()
        googleButton.setTitle("google Login", for: .normal)
        googleButton.setTitleColor(.label, for: .normal)
        googleButton.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .semibold)
        googleButton.backgroundColor = .systemBackground
        googleButton.layer.cornerRadius = 3.0
        
        return googleButton
    }()
    
    private lazy var emailImage: UIImageView = {
        let emailmage = UIImageView()
        emailmage.image = UIImage(systemName: "mail")
        emailmage.contentMode = .scaleAspectFit

        return emailmage
    }()
    
    private lazy var emailButton: UIButton = {
        let emailButton = UIButton()
        emailButton.setTitle("Email Login", for: .normal)
        emailButton.setTitleColor(.label, for: .normal)
        emailButton.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .semibold)
        emailButton.backgroundColor = .systemBackground
        emailButton.layer.cornerRadius = 3.0
        
        return emailButton
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            appleStackView,
            kakaoStackView,
            googleStackView,
            emailStackView
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 6.0
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var appleStackView: UIStackView = {
        let appleStackView = UIStackView(arrangedSubviews: [
            appleImage,
            appleButton
        ])
        
        appleStackView.axis = .horizontal
        appleStackView.spacing = 5.0
        appleStackView.distribution = .equalSpacing
            
        return appleStackView
    }()
    
    private lazy var kakaoStackView: UIStackView = {
        let kakaoStackView = UIStackView(arrangedSubviews: [
            kakaoImage,
            kakaoButton
        ])
        
        kakaoStackView.axis = .horizontal
        kakaoStackView.spacing = 5.0
        kakaoStackView.distribution = .equalSpacing
            
        return kakaoStackView
    }()
    
    private lazy var googleStackView: UIStackView = {
        let googleStackView = UIStackView(arrangedSubviews: [
            googleImage,
            googleButton
        ])
        
        googleStackView.axis = .horizontal
        googleStackView.spacing = 5.0
        googleStackView.distribution = .equalSpacing
            
        return googleStackView
    }()
    
    private lazy var emailStackView: UIStackView = {
        let emailStackView = UIStackView(arrangedSubviews: [
            emailImage,
            emailButton
        ])
        
        emailStackView.axis = .horizontal
        emailStackView.spacing = 5.0
        emailStackView.distribution = .equalSpacing
            
        return emailStackView
    }()
    
    
    // apple 로그인 버튼 클릭시
    let appleLoginButtonTapped = PublishRelay<Void>()
    
    // kakao 로그인 버튼 클릭시
    let kakaoLoginButtonTapped = PublishRelay<Void>()
    
    // google 로그인 버튼 클릭시
    let googleLoginButtonTapped = PublishRelay<Void>()
    
    // Email 로그인 버튼 클릭시
    let emailLoginButtonTapped = PublishRelay<Void>()
    
    // 외부로 내보낼 이벤트
    var shouldLoadResult = Observable<String>.of("")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        
        bind()
        setupLayout()
    }
}

private extension LoginViewController {
    
    
    
    func bind() {
        appleButton.rx.tap
            .bind(to: appleLoginButtonTapped)
            .disposed(by: disposeBag)
        
        kakaoButton.rx.tap
            .bind(to: kakaoLoginButtonTapped)
            .disposed(by: disposeBag)
        
        googleButton.rx.tap
            .bind(to: googleLoginButtonTapped)
            .disposed(by: disposeBag)
        
        emailButton.rx.tap
//            .bind(to: emailLoginButtonTapped)
            .bind {
                let vc = EmailLoginViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
    func attribute() {
        
    }
    
    func setupLayout() {
        [
            imageView,
            titleLabel,
            stackView
        ].forEach{ view.addSubview($0) }
        
        let imageViewWidth = 200.0
        imageView.snp.makeConstraints {
            $0.width.equalTo(imageViewWidth)
            $0.height.equalTo(imageViewWidth)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-180)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
        }

    }
}
