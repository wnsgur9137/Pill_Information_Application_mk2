//
//  ProfileUpdateView.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProfileUpdateView: UIViewController {
    
    
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
    
    private lazy var updateButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private lazy var outButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            outButton
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile Update"
        
        bind()
        setupLayout()
    }
}

private extension ProfileUpdateView {
    func bind() {
        
    }
    
    func setupLayout() {
        
    }
}
