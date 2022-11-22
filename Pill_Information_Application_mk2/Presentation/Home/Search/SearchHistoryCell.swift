//
//  SearchHistoryCell.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/11/22.
//

import UIKit
import SnapKit

final class SearchHistoryCell: UICollectionViewCell {
    
    private lazy var background: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 5.0
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor(named: "label")?.cgColor
        return view
    }()
    
    lazy var searchHistoryLabel: UILabel = {
        let label = UILabel()
        label.text = "탁센"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
}

private extension SearchHistoryCell {
    func setupLayout() {
        [
            background,
            searchHistoryLabel
        ].forEach{ addSubview($0) }
        
        background.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
//            $0.width.equalTo(100.0)
//            $0.height.equalTo(34.0)
            $0.width.equalTo(searchHistoryLabel.snp.width)
        }
        
        searchHistoryLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
