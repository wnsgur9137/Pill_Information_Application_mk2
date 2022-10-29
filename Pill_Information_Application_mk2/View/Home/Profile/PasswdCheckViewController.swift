//
//  PasswdCheckViewController.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PasswdCheckViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    
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
        label.text = "비밀번호 확인"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var passwdLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var passwdTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray
        textField.isSecureTextEntry = true
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
