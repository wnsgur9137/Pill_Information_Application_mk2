//
//  DetailTableViewCell.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/11/14.
//

import UIKit
import SnapKit

final class DetailTableViewCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "내용"
        label.textColor = .label
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupLayout()
    }
}

private extension DetailTableViewCell {
    func setupLayout() {
        [
            titleLabel,
            contentLabel
        ].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.equalToSuperview().offset(5.0)
            $0.leading.equalToSuperview().offset(5.0)
            $0.bottom.equalToSuperview().offset(-5.0)
            $0.width.equalTo(100.0)
        }
        
        contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.top)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(15.0)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.bottom)
        }
    }
}
