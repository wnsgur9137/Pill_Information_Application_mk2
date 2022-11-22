//
//  Alarm.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/11/21.
//

import Foundation

struct Alarm: Codable {
    var id: String = UUID().uuidString
    var date: Date  // 날짜
    var isOn: Bool  // 스위치 on/off
    
    var time: String {  // 시간
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm"
        
        return timeFormatter.string(from: date)
    }
    
    var meridiem: String {  // 오전/오후
        let meridiemFormatter = DateFormatter()  // 오전, 오후
        meridiemFormatter.dateFormat = "a"
        meridiemFormatter.locale = Locale(identifier: "ko")  // locale 한국으로 설정
        return meridiemFormatter.string(from: date)
    }
    
    var pillName: String  // 먹을 약 이름
}
