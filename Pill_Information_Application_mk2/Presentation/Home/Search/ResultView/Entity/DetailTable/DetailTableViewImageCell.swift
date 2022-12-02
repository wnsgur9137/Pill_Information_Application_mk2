//
//  DetailTableViewImageCell.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/12/02.
//

import UIKit
import SnapKit

final class DetailTableViewImageCell: UITableViewCell {
    
    lazy var pillImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 3.0
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupLayout()
    }
}

private extension DetailTableViewImageCell {
    func setupLayout() {
        addSubview(pillImageView)
        
        pillImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(180.0)
        }
    }
}
