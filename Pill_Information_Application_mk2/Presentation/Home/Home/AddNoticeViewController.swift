//
//  AddNoticeViewController.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/11/02.
//

import UIKit
import SnapKit
import Alamofire
import RxSwift
import RxCocoa

final class AddNoticeViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    var keyboardCheck = true
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "공지사항 제목".localized()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        return label
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray2
        return textField
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "공지사항 내용".localized()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        return label
    }()
    
    private lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.textColor = .black
        textView.font = .systemFont(ofSize: 14.0, weight: .regular)
        textView.backgroundColor = UIColor(named: "paperColor")
        return textView
    }()
    
    private lazy var addNoticeButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장".localized(), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "공지사항 추가".localized()
        bind()
        setupLayout()
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
}

private extension AddNoticeViewController {
    func bind() {
        
        addNoticeButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                
                let urlTitle = (self.titleTextField.text ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let urlWriter = (UserDefaults.standard.string(forKey: "nickname")!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let urlContent = (self.contentTextView.text ?? "").replacingOccurrences(of: "\n", with: "%5Cn").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                
                let param = "?title=\(urlTitle)&writer=\(urlWriter)&content=\(urlContent)"
                
//                let url = "\(FastAPI.host + FastAPI.path)/setNotice/\(param)"
                let url = "\(ubuntuServer.host + ubuntuServer.path)/setNotice/\(param)"
                
                AF.request(url, method: .post)
                    .response(completionHandler: { response in
                        switch response.result {
                        case let .success(data):
                            print("success: \(String(describing: data))")
                            let alertCon = UIAlertController(title: "성공".localized(), message: "공지사항 작성 완료".localized(), preferredStyle: UIAlertController.Style.alert)
                            let alertAct = UIAlertAction(title: "확인".localized(), style: UIAlertAction.Style.default, handler: { _ in
                                self.dismiss(animated: true)
                            })
                            alertCon.addAction(alertAct)
                            self.present(alertCon, animated: true, completion: nil)
                        case let .failure(error):
                            print("failure: \(error)")
                            let alertCon = UIAlertController(title: "오류".localized(), message: "공지사항 작성에 실패하였습니다.".localized(), preferredStyle: UIAlertController.Style.alert)
                            let alertAct = UIAlertAction(title: "확인".localized(), style: UIAlertAction.Style.default)
                            alertCon.addAction(alertAct)
                            self.present(alertCon, animated: true)
                        }
                    })
                
                print(url)
                print("param: \(param)")
                
            })
            .disposed(by: disposeBag)
    }
    
    func setupLayout() {
        [
            backgroundView,
            titleLabel,
            titleTextField,
            contentLabel,
            contentTextView,
            addNoticeButton
        ].forEach { view.addSubview($0) }
    
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalToSuperview().offset(10)
        }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(34)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(40)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(10)
            $0.leading.equalTo(contentLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(70)
        }
        
        addNoticeButton.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().inset(30)
        }
    }
}
