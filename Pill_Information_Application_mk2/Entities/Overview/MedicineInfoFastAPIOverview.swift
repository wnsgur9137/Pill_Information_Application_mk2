//
//  MedicineInfoFastAPIOverview.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/11/09.
//

import Foundation

struct MedicineInfoFastAPIOverview: Codable {
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
        case medicineName = "drugName"
        case medicineSeq = "drugSeq"
        case efcyQesitm = "efcyQesitm"
        case useMethodQesitm = "useMethodQesitm"
        case atpnWarnQesitm = "atpnWarnQesitm"
        case atpnQesitm = "atpnQesitm"
        case intrcQesitm = "intrcQesitm"
        case seQesitm = "seQesitm"
        case depositMethodQesitm = "depositMethodQesitm"
        case openDate = "openDe"
        case updateDate = "updateDe"
        case medicineImage = "drugImage"
    }
}

//{
//  "drugSeq": "198401161",
//  "drugName": "세나서트2밀리그람질정",
//  "entpName": "알보젠코리아(주)",
//  "efcyQesitm": "이 약은 세균성질증에 사용합니다.",
//  "useMethodQesitm": "성인은 1회 1정, 1일 1회 질내 깊숙이 삽입합니다.",
//  "atpnWarnQesitm": null,
//  "atpnQesitm": "이 약에 과민증 환자는 이 약을 사용하지 마십시오.이 약은 질에만 사용하고 내복용으로는 사용하지 마십시오.이 약은 콘돔, 질내피임용격막과 같은 라텍스 또는 고무제품을 약화시킬 수 있으므로 주의하십시오.",
//  "intrcQesitm": null,
//  "seQesitm": "자극감 등이 나타나는 경우 사용을 즉각 중지하고 의사 또는 약사와 상의하십시오.",
//  "depositMethodQesitm": "습기와 빛을 피해 서늘한 곳에 보관하십시오.",
//  "openDe": "2021-01-29 00:00:00",
//  "updateDe": "2021January29th",
//  "drugImage": "HTTPS://NEDRUG.MFDS.GO.KR/PBP/CMN/ITEMIMAGEDOWNLOAD/1NOwp2F6EVc"
//}
