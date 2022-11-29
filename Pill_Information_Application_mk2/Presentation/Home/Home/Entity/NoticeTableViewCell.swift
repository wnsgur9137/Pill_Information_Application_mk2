//
//  NoticeTableViewCell.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/11/07.
//

import UIKit
import SnapKit

final class NoticeTableViewCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "공지사항".localized()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(contentView.safeAreaLayoutGuide).offset(15.0)
        }
    }
    
    func setData(_ title: String) {
        titleLabel.text = title
    }
}
