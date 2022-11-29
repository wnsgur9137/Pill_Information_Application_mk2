//
//  UNNotificationCenter.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/11/21.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter {
    func addNotificationRequest(by alarm: Alarm) {
        let content = UNMutableNotificationContent()
        let taking = alarm.pillName
        content.title = taking + " 먹을 시간이에요. 💊".localized()
        content.body = "약 먹기 전 식사는 하셨나요? 👀".localized()
        content.sound = .default
        content.badge = 1
        
        let component = Calendar.current.dateComponents([.hour, .minute], from: alarm.date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        
        //request 생성
        let request = UNNotificationRequest(identifier: alarm.id, content: content, trigger: trigger)
            
        self.add(request, withCompletionHandler: nil)
    }
    
}
