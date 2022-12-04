//
//  DetailTableViewWarningCell.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/12/04.
//

import UIKit
import SnapKit
import SafariServices

final class DetailTableViewWarningCell: UITableViewCell {
    lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.text = "필수 지침".localized() + "\n" + "앱 사용 경고 사항".localized()
        label.textColor = .label
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var linkLabel: UILabel = {
        let label = UILabel()
        label.text = "koreaPharmaceuticalInfoCenter".localized()
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 12.0, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupLayout()
    }
}

private extension DetailTableViewWarningCell {
    
    @objc func fixedLabelTapped(_ sender: UITapGestureRecognizer) {
        //fixedLabel에서 UITapGestureRecognizer로 선택된 부분의 CGPoint를 구합니다.
        let point = sender.location(in: linkLabel)
        
        // fixedLabel 내에서 문자열 google이 차지하는 CGRect값을 구해, 그 안에 point가 포함되는지를 판단합니다.
        
        if let koreaRect = linkLabel.boundingRectForCharacterRange(subText: "koreaPharmaceuticalInfoCenter".localized()), koreaRect.contains(point) {
            let alertCon = UIAlertController(
                title: "앱 외부 사이트로 전환".localized(),
                message: nil,
                preferredStyle: UIAlertController.Style.alert
            )
            let alertActYes = UIAlertAction(
                title: "이동".localized(),
                style: UIAlertAction.Style.default,
                handler: { [weak self] _ in
                    self?.present(url: "https://www.health.kr/")
                }
            )
            let alertActNo = UIAlertAction(
                title: "취소".localized(),
                style: UIAlertAction.Style.cancel
            )
            [
                alertActYes,
                alertActNo
            ].forEach{alertCon.addAction($0)}
            self.window?.rootViewController?.present(alertCon, animated: true)
        }
    }
    
    func present(url string: String) {
      if let url = URL(string: string) {
        let viewController = SFSafariViewController(url: url)
          self.window?.rootViewController?.present(viewController, animated: true)
      }
    }
    
    func setupLayout() {
        [
            warningLabel,
            linkLabel
        ].forEach{ addSubview($0) }
        
        
    }
}
