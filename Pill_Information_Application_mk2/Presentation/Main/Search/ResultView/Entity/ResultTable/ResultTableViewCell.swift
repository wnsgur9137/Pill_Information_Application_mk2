//
//  ResultTableViewCell.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/11/08.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

import Kingfisher

final class ResultTableViewCell: UITableViewCell {
    
    private lazy var medicineImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private lazy var medicineNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var classNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private lazy var etcOtcNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18.0, weight: .regular)
        label.textColor = .white
        label.backgroundColor = .systemGray
        return label
    }()
    
    private lazy var clickImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.compact.right")
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
        setupLayout()
    }
    
    func setData(data: ResultTableViewCellData) {
        let medicineImageURL = URL(string: data.medicineImage ?? "")
        medicineImageView.kf.setImage(
            with: medicineImageURL!,
            placeholder: UIImage(systemName: "photo")
        )
        medicineNameLabel.text = data.medicineName
        classNameLabel.text = data.className
        etcOtcNameLabel.text = data.etcOtcName
    }
    
    func setDataFastAPI(data: MedicineFastAPIItem) {
        let medicineImageURL = URL(string: data.medicineImage ?? "")
        medicineImageView.kf.setImage(
            with: medicineImageURL!,
            placeholder: UIImage(systemName: "photo")
        )
        medicineNameLabel.text = data.medicineName
        classNameLabel.text = data.className
        etcOtcNameLabel.text = data.etcOtcName
    }
}

private extension ResultTableViewCell {
    func setupLayout() {
        [
            medicineImageView,
            classNameLabel,
            etcOtcNameLabel,
            medicineNameLabel,
            clickImageView
        ].forEach { addSubview($0) }
        
        medicineImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(8.0)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(80.0)
            
        }
        
        clickImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-8.0)
            $0.height.equalTo(25.0)
            $0.width.equalTo(10.0)
        }
        
        classNameLabel.snp.makeConstraints {
            $0.top.equalTo(medicineImageView.snp.top)
            $0.leading.equalTo(medicineImageView.snp.trailing).offset(10.0)
            $0.trailing.equalTo(etcOtcNameLabel.snp.leading).offset(-10.0)
        }
        
        etcOtcNameLabel.snp.makeConstraints {
            $0.top.equalTo(medicineImageView.snp.top)
            $0.trailing.equalTo(clickImageView).offset(-8.0)
            $0.width.equalTo(80.0)
        }
        
        medicineNameLabel.snp.makeConstraints {
            $0.top.equalTo(classNameLabel.snp.bottom).offset(5.0)
            $0.leading.equalTo(classNameLabel.snp.leading)
            $0.trailing.equalTo(clickImageView).offset(-8.0)
//            $0.width.equalTo(300.0)
        }
    }
}


