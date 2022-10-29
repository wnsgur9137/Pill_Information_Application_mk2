//
//  noticeDetailViewController.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/29.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class noticeDetailViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupLayout()
    }
}

private extension noticeDetailViewController {
    func bind() {
        
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
}
