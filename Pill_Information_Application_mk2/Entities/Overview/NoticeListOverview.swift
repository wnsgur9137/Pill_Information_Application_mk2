//
//  NoticeOverview.swift
//  Pill_Information_Application_mk2
//  Created by 이준혁 on 2022/11/06.
//

import Foundation

struct NoticeListOverview: Codable {
    let noticeList: [NoticeOverview]
}

struct NoticeOverview: Codable {
    let id: Int?
    let title: String?
    let writer: String?
    let content: String?
}
