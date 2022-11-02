//
//  NoticeDetailViewController.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/29.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NoticeDetailViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textColor = .label
        label.font = .systemFont(ofSize: 30.0, weight: .bold)
        return label
    }()
    
    private lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.text = "Content"
        textView.textColor = .black
        textView.font = .systemFont(ofSize: 14.0, weight: .regular)
        textView.backgroundColor = UIColor(named: "paperColor")
        return textView
    }()
    
    private lazy var helpLabel: UILabel = {
        let label = UILabel()
        label.text = "고객지원"
        label.textColor = .label
        label.font = .systemFont(ofSize: 17.0, weight: .bold)
        return label
    }()
    
    private lazy var helpEmail: UILabel = {
        let label = UILabel()
        label.text = "Email: wnsgur9137@icloud.com"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        return label
    }()
    
    private lazy var updateButton: UIButton = {
        let button = UIButton()
        button.setTitle("수정", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .bold)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "공지사항"
        bind()
        setupLayout()
        
        if UserDefaults.standard.string(forKey: "email") == "wnsgur9137@icloud.com" {
            addAdminLayout()
        }
    }
}

private extension NoticeDetailViewController {
    func bind() {
        updateButton.rx.tap
            .bind(onNext: {
                
            })
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .bind(onNext: {
                
            })
            .disposed(by: disposeBag)
    }
    
    func setupLayout() {
        [
            backgroundView,
            titleLabel,
            contentTextView,
            helpLabel,
            helpEmail
        ].forEach { view.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalToSuperview().offset(10)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(120)
        }
        
        helpLabel.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(40)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        helpEmail.snp.makeConstraints {
            $0.top.equalTo(helpLabel.snp.bottom).offset(10)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(helpLabel.snp.trailing)
        }
    }
    
    func addAdminLayout() {
        [
            updateButton,
            deleteButton
        ].forEach { view.addSubview($0) }
        
        updateButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.top)
            $0.trailing.equalTo(deleteButton.snp.leading).offset(-10)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(updateButton.snp.top)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
