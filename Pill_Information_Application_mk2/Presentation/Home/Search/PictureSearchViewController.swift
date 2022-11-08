//
//  PictureSearchViewController.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/31.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PictureSearchViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Pill_Image")
        return imageView
    }()
    
    private lazy var choiceImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("사진 재선택", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(choiceImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shapeLabel: UILabel = {
        let label = UILabel()
        label.text = "의약품 모양"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        return label
    }()
    
    private lazy var shapeTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    private lazy var colorLabel: UILabel = {
        let label = UILabel()
        label.text = "색상"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        return label
    }()
    
    private lazy var colorTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    private lazy var lineLabel: UILabel = {
        let label = UILabel()
        label.text = "분할선"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        return label
    }()
    
    private lazy var lineTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    private lazy var markCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "마크 코드"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        return label
    }()
    
    private lazy var markCodeTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("검색", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var textFieldStackView: UIStackView = {
        let shapeStackView = UIStackView(arrangedSubviews: [shapeLabel, shapeTextField])
        shapeStackView.axis = .horizontal
        shapeStackView.distribution = .fill
        shapeStackView.spacing = 10.0
        
        let colorStackView = UIStackView(arrangedSubviews: [colorLabel, colorTextField])
        colorStackView.axis = .horizontal
        colorStackView.distribution = .fill
        colorStackView.spacing = 10.0
        
        let lineStackView = UIStackView(arrangedSubviews: [lineLabel, lineTextField])
        lineStackView.axis = .horizontal
        lineStackView.distribution = .fill
        lineStackView.spacing = 10.0
        
        let markCodeStackView = UIStackView(arrangedSubviews: [markCodeLabel, markCodeTextField])
        markCodeStackView.axis = .horizontal
        markCodeStackView.distribution = .fill
        markCodeStackView.spacing = 10.0
        
        
        let stackView = UIStackView(arrangedSubviews: [
            shapeStackView,
            colorStackView,
            lineStackView,
            markCodeStackView
        ])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10.0
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "사진으로 검색"
        bind()
        setupLayout()
    }
    
}

private extension PictureSearchViewController {
    func bind() {
        
    }
    
    @objc func choiceImageButtonTapped() {
        
    }
    
    @objc func searchButtonTapped() {
        
    }
    
    func setupLayout() {
        [
            backgroundView,
            pictureImageView,
            choiceImageButton,
            textFieldStackView,
            searchButton
        ].forEach{ view.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        pictureImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(240.0)
            $0.height.equalTo(240.0)
        }
        
        choiceImageButton.snp.makeConstraints {
            $0.top.equalTo(pictureImageView.snp.bottom).offset(10.0)
            $0.centerX.equalToSuperview()
        }
        
        textFieldStackView.snp.makeConstraints {
            $0.top.equalTo(choiceImageButton.snp.bottom).offset(50.0)
            $0.leading.equalToSuperview().offset(10.0)
            $0.trailing.equalToSuperview().inset(10.0)
            
            [shapeLabel, colorLabel, lineLabel, markCodeLabel].forEach {
                $0.snp.makeConstraints {
                    $0.width.equalTo(150.0)
                    $0.height.equalTo(34.0)
                }
            }
            
        }
        
        searchButton.snp.makeConstraints {
            $0.top.equalTo(textFieldStackView.snp.bottom).offset(50.0)
            $0.centerX.equalToSuperview()
        }
        
        
    }
}
