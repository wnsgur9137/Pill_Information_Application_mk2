//
//  LocalizableString.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/11/29.
//

import Foundation

extension String {
    
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    func localized(with argument: CVarArg = [], comment: String = "") -> String {
        return String(format: self.localized(comment: comment), argument)
    }
}
