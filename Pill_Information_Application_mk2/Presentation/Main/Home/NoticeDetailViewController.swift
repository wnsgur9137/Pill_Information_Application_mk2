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

import Alamofire

final class NoticeDetailViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var noticeId: Int? = nil
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "작성자: Title".localized()
        label.textColor = .label
        label.font = .systemFont(ofSize: 30.0, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var writerLabel: UILabel = {
        let label = UILabel()
        label.text = "Admin"
        label.textColor = .label
        label.font = .systemFont(ofSize: 20.0, weight: .regular)
        return label
    }()
    
    private lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.text = "Content"
        textView.textColor = .black
        textView.font = .systemFont(ofSize: 18.0, weight: .regular)
        textView.backgroundColor = UIColor(named: "paperColor")
        
        return textView
    }()
    
    private lazy var helpLabel: UILabel = {
        let label = UILabel()
        label.text = "고객지원".localized()
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
        button.setTitle("수정".localized(), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .bold)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제".localized(), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "공지사항".localized()
        bind()
        setupLayout()
        
        if UserDefaults.standard.string(forKey: "email") == "wnsgur9137@icloud.com" ||
            UserDefaults.standard.string(forKey: "email") == "admin@admin.com" {
            addAdminLayout()
        }
        keyboardAttribute()
    }
    
    func keyboardAttribute() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
            tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func setData(id: Int, title: String, writer: String, content: String) {
        noticeId = id
        titleLabel.text = title.removingPercentEncoding
//        writerLabel.text = "작성자: \(String(describing: writer.removingPercentEncoding ?? "Admin"))"
        writerLabel.text = "작성자: %@".localized(with: String(describing: writer.removingPercentEncoding ?? "Admin"))
        contentTextView.text = content.removingPercentEncoding?.replacingOccurrences(of: "\\n", with: "\n")
    }
}

private extension NoticeDetailViewController {
    func bind() {
        updateButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.view.endEditing(true)
                let vc = UpdateNoticeViewController()
                vc.setData(id: self.noticeId!, title: self.titleLabel.text!, content: self.contentTextView.text!)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.view.endEditing(true)
                let alertCon = UIAlertController(title: "공지사항을 삭제하시겠습니까?".localized(), message: nil, preferredStyle: UIAlertController.Style.alert)
                let alertAcc = UIAlertAction(title: "아니오".localized(), style: UIAlertAction.Style.default)
                let alertCancel = UIAlertAction(title: "예".localized(), style: UIAlertAction.Style.destructive, handler: { _ in
                    self?.deleteNotice()
                })
                alertCon.addAction(alertAcc)
                alertCon.addAction(alertCancel)
                self?.present(alertCon, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func updateNotice() {
        
    }
    
    func deleteNotice() {
//        let url = "\(FastAPI.host + FastAPI.path)/deleteNotice/?id=\(String(describing: noticeId!))"
        let url = "\(ubuntuServer.host + ubuntuServer.path)/deleteNotice/?id=\(String(describing: noticeId!))"
        
        AF.request(url, method: .post)
            .response(completionHandler: { [weak self] response in
                switch response.result {
                case let .success(data):
                    print("success: \(String(describing: data))")
                    self?.dismiss(animated: true)
                case let .failure(error):
                    print("failure: \(error)")
                }
            })
    }
    
    func setupLayout() {
        [
            backgroundView,
            titleLabel,
            writerLabel,
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
            $0.trailing.equalToSuperview().inset(130)
        }
        
        writerLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(writerLabel.snp.bottom).offset(20)
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
