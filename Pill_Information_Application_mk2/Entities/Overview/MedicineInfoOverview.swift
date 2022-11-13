//
//  MedicineInfoOverview.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/11/09.
//

import Foundation

struct MedicineInfoOverview: Decodable {
    let body: MedicineInfoBody
}

struct MedicineInfoBody: Decodable {
    let pageNo: Int
    let totalCount: Int
    let numOfRows: Int
    let items: [MedicineInfoItem]
}

struct MedicineInfoItem: Decodable {
    let entpName: String?
    let medicineName: String?
    let medicineSeq: String?
    let efcyQesitm: String?
    let useMethodQesitm: String?
    let atpnWarnQesitm: String?
    let atpnQesitm: String?
    let intrcQesitm: String?
    let seQesitm: String?
    let depositMethodQesitm: String?
    let openDate: String?
    let updateDate: String?
    let medicineImage: String?
    
    enum CodingKeys: String, CodingKey {
        case entpName = "entpName"
        case medicineName = "itemName"
        case medicineSeq = "itemSeq"
        case efcyQesitm = "efcyQesitm"
        case useMethodQesitm = "useMethodQesitm"
        case atpnWarnQesitm = "atpnWarnQesitm"
        case atpnQesitm = "atpnQesitm"
        case intrcQesitm = "intrcQesitm"
        case seQesitm = "seQesitm"
        case depositMethodQesitm = "depositMethodQesitm"
        case openDate = "openDe"
        case updateDate = "updateDe"
        case medicineImage = "itemImage"
    }
}

//{
//  "header": {
//    "resultCode": "00",
//    "resultMsg": "NORMAL SERVICE."
//  },
//  "body": {
//    "pageNo": 1,
//    "totalCount": 1,
//    "numOfRows": 3,
//    "items": [
//      {
//        "entpName": "지엘파마(주)",
//        "itemName": "지엘타이밍정(카페인무수물)",
//        "itemSeq": "196500051",
//        "efcyQesitm": "<p>이 약은 졸음에 사용합니다.</p>",
//        "useMethodQesitm": "<p>성인은 1회 2~6정(100~300 mg)씩, 1일 1~3회 복용합니다.</p><p>연령, 증상에 따라 적절히 증감할 수 있습니다.</p>",
//        "atpnWarnQesitm": null,
//        "atpnQesitm": "<p>갈락토오스 불내성, Lapp 유당분해효소 결핍증 또는 포도당-갈락토오스 흡수장애 등의 유전적인 문제가 있는 환자는 이 약을 복용하지 마십시오.</p><p>이 약을 복용하기 전에 임부 또는 임신하고 있을 가능성이 있는 여성 및 수유부, 고령자, 위궤양 환자 또는 경험자, 심질환, 녹내장 환자는 의사 또는 약사와 상의하십시오.</p>",
//        "intrcQesitm": null,
//        "seQesitm": "<p>만성 녹내장을 악화시킬 경우 복용을 즉각 중지하고 의사 또는 약사와 상의하십시오.</p>",
//        "depositMethodQesitm": "<p>실온에서 보관하십시오.</p><p>어린이의 손이 닿지 않는 곳에 보관하십시오.</p>",
//        "openDe": "2021-10-01 00:00:00",
//        "updateDe": "20211001",
//        "itemImage": "https://nedrug.mfds.go.kr/pbp/cmn/itemImageDownload/1NAT_bwbZd9"
//      }
//    ]
//  }
//}
