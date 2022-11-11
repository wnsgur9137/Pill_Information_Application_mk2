//
//  ResultTableViewHeader.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/11/11.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ResultTableViewHeader: UITableViewHeaderFooterView {
    let disposeBag = DisposeBag()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        return button
    }()
    
    private lazy var bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let sortButtonTapped = PublishRelay<Void>()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        bind()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ResultTableViewHeader {
    func bind() {
        sortButton.rx.tap
            .bind(to: sortButtonTapped)
            .disposed(by: disposeBag)
    }
    
    func layout() {
        [
            sortButton,
            bottomBorder
        ].forEach { addSubview($0) }
        
        sortButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12.0)
            $0.width.height.equalTo(28.0)
        }
    }
}
