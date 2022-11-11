//
//  AlertActionConvertible.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/11/11.
//

import UIKit

protocol AlertActionConvertible {
    var title: String { get }
    var style: UIAlertAction.Style { get }
}
