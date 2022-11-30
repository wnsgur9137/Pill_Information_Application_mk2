//
//  EmptyTableView.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/12/01.
//

import Foundation
import UIKit

extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel: UILabel = {
            let label = UILabel()
            label.text = message
            label.textColor = .black
            label.backgroundColor = .lightGray
            label.numberOfLines = 0;
            label.textAlignment = .center;
            label.font = UIFont(name: "BM JUA_OTF", size: 15)
            label.sizeToFit()
            return label
        }()
        self.backgroundView = messageLabel;
    }
    // 2
    func restore() {
        self.backgroundView = nil
    }
}
