//
//  KeyboardNotification.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/11/28.
//

import Foundation
import UIKit

//// 노티피케이션을 추가하는 메서드
//func addKeyboardNotifications(){
//    // 키보드가 나타날 때 앱에게 알리는 메서드 추가
//    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
//    // 키보드가 사라질 때 앱에게 알리는 메서드 추가
//    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//}
//
//// 노티피케이션을 제거하는 메서드
//func removeKeyboardNotifications(){
//    // 키보드가 나타날 때 앱에게 알리는 메서드 제거
//    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
//    // 키보드가 사라질 때 앱에게 알리는 메서드 제거
//    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//}
//
//// 키보드가 나타났다는 알림을 받으면 실행할 메서드
//@objc func keyboardWillShow(_ noti: NSNotification){
//    // 키보드의 높이만큼 화면을 올려준다.
//    if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//        let keyboardRectangle = keyboardFrame.cgRectValue
//        let keyboardHeight = keyboardRectangle.height
//        self.view.frame.origin.y -= keyboardHeight
//    }
//}
//
//// 키보드가 사라졌다는 알림을 받으면 실행할 메서드
//@objc func keyboardWillHide(_ noti: NSNotification){
//    // 키보드의 높이만큼 화면을 내려준다.
//    if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//        let keyboardRectangle = keyboardFrame.cgRectValue
//        let keyboardHeight = keyboardRectangle.height
//        self.view.frame.origin.y += keyboardHeight
//    }
//}

