//
//  MedicineFastAPIOverview.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/11/09.
//

import Foundation

struct MedicineFastAPIOverview: Codable {
    let resultCount: Int
    let medicineItem: [MedicineFastAPIItem]
}


struct MedicineFastAPIItem: Codable {
    let medicineSeq: String?
    let medicineName: String?
    let entpSeq: String?
    let entpName: String?
    let chart: String?
    let medicineImage: String?
    let printFront: String?
    let printBack: String?
    let medicineShape: String?
    let colorClass1: String?
    let colorClass2: String?
    let lineFront: String?
    let lineBack: String?
    let lengLong: String?
    let lengShort: String?
    let thick: String?
    let imgRegistTs: String?
    let classNo: String?
    let className: String?
    let etcOtcName: String?
    let medicinePermitDate: String?
    let formCodeName: String?
    let markCodeFrontAnal: String?
    let markCodeBackAnal: String?
    let markCodeFrontImage: String?
    let markCodeBackImage: String?
    let medicineEngName: String?
    let changeDate: String?
    let markCodeFront: String?
    let markCodeBack: String?
    let ediCode: String?
    
//    enum CodingKeys: String, CodingKey {
//        case medicineSeq
//        case medicineName
//        case entpSeq
//        case entpName
//        case chart
//        case medicineImage
//        case printFront
//        case printBack
//        case medicineShape
//        case colorClass1
//        case colorClass2
//        case lineFront
//        case lineBack
//        case lenLong = "lengLong"
//        case lenShort = "lengShort"
//        case thick
//        case imgRegistTs
//        case classNo
//        case className
//        case etcOtcName
//        case medicinePermitDate
//        case formCodeName
//        case markCodeFrontAnal
//        case markBackAnal
//        case markCodeFrontImage
//        case markCodeBackImage
//        case medicineEngName
//        case updateDate = "changeDate"
//        case markCodeFront
//        case markCodeBack
//        case ediCode
//    }
}
    
//    enum CodingKeys: String, CodingKey {
//        case medicineSeq = "ITEM_SEQ"
//        case medicineName = "ITEM_NAME"
//        case entpSeq = "ENTP_SEQ"
//        case entpName = "ENTP_NAME"
//        case chart = "CHART"
//        case medicineImage = "ITEM_IMAGE"
//        case printFront = "PRINT_FRONT"
//        case printBack = "PRINT_BACK"
//        case medicineShape = "DRUG_SHAPE"
//        case colorClass1 = "COLOR_CLASS1"
//        case colorClass2 = "COLOR_CLASS2"
//        case lineFront = "LINE_FRONT"
//        case lineBack = "LINE_BACK"
//        case lenLong = "LENG_LONG"
//        case lenShort = "LENG_SHORT"
//        case thick = "THICK"
//        case imgRegistTs = "IMG_REGIST_TS"
//        case classNo = "CLASS_NO"
//        case className = "CLASS_NAME"
//        case etcOtcName = "ETC_OTC_NAME"
//        case medicinePermitDate = "ITEM_PERMIT_DATE"
//        case formCodeName = "FORM_CODE_NAME"
//        case markCodeFrontAnal = "MARK_CODE_FRONT_ANAL"
//        case markCodeBackAnal = "MARK_CODE_BACK_ANAL"
//        case markCodeFrontImage = "MARK_CODE_FRONT_IMG"
//        case markCodeBackImage = "MARK_CODE_BACK_IMG"
//        case medicineEngName = "ITEM_ENG_NAME"
//        case updateDate = "CHANGE_DATE"
//        case markCodeFront = "MARK_CODE_FRONT"
//        case markCodeBack = "MARK_CODE_BACK"
//        case ediCode = "EDI_CODE"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//
//        self.medicineSeq = try? values.decode(String?.self, forKey: .medicineSeq)
//        self.medicineName = try? values.decode(String?.self, forKey: .medicineName)
//        self.entpSeq = try? values.decode(String?.self, forKey: .entpSeq)
//        self.entpName = try? values.decode(String?.self, forKey: .entpName)
//        self.chart = try? values.decode(String?.self, forKey: .chart)
//        self.medicineImage = try? values.decode(String?.self, forKey: .medicineImage)
//        self.printFront = try? values.decode(String?.self, forKey: .printFront)
//        self.printBack = try? values.decode(String?.self, forKey: .printBack)
//        self.medicineShape = try? values.decode(String?.self, forKey: .medicineShape)
//        self.colorClass1 = try? values.decode(String?.self, forKey: .colorClass1)
//        self.colorClass2 = try? values.decode(String?.self, forKey: .colorClass2)
//        self.lineFront = try? values.decode(String?.self, forKey: .lineFront)
//        self.lineBack = try? values.decode(String?.self, forKey: .lineBack)
//        self.lenLong = try? values.decode(String?.self, forKey: .lenLong)
//        self.lenShort = try? values.decode(String?.self, forKey: .lenShort)
//        self.thick = try? values.decode(String?.self, forKey: .thick)
//        self.imgRegistTs = try? values.decode(String?.self, forKey: .imgRegistTs)
//        self.classNo = try? values.decode(String?.self, forKey: .classNo)
//        self.className = try? values.decode(String?.self, forKey: .className)
//        self.etcOtcName = try? values.decode(String?.self, forKey: .etcOtcName)
//        self.medicinePermitDate = try? values.decode(String?.self, forKey: .medicinePermitDate)
//        self.formCodeName = try? values.decode(String?.self, forKey: .formCodeName)
//        self.markCodeFrontAnal = try? values.decode(String?.self, forKey: .markCodeFrontAnal)
//        self.markCodeBackAnal = try? values.decode(String?.self, forKey: .markCodeBackAnal)
//        self.markCodeFrontImage = try? values.decode(String?.self, forKey: .markCodeFrontImage)
//        self.markCodeBackImage = try? values.decode(String?.self, forKey: .markCodeBackImage)
//        self.medicineEngName = try? values.decode(String?.self, forKey: .medicineEngName)
//        self.updateDate = try? values.decode(String?.self, forKey: .updateDate)
//        self.markCodeFront = try? values.decode(String?.self, forKey: .markCodeFront)
//        self.markCodeBack = try? values.decode(String?.self, forKey: .markCodeBack)
//        self.ediCode = try? values.decode(String?.self, forKey: .ediCode)
//    }
//}

//{
//  "resultCount": 4,
//  "medicineList": [
//    {
//      "medicineSeq": "202106092",
//      "medicineName": "타이레놀정500밀리그람(아세트아미노펜)",
//      "entpSeq": "20160476",
//      "chart": "흰색의 장방형 필름코팅정제",
//      "medicineImage": "https://nedrug.mfds.go.kr/pbp/cmn/itemImageDownload/1N-M7iZWRP9",
//      "printFront": "TYLENOL",
//      "printBack": "500",
//      "medicineShape": "장방형",
//      "colorClass1": "하양",
//      "colorClass2": null,
//      "lineFront": null,
//      "lineBack": null,
//      "lengLong": "17.6",
//      "lengShort": "7.1",
//      "thick": "5.7",
//      "imgRegistTs": "20220322",
//      "classNo": "01140",
//      "className": "해열.진통.소염제",
//      "etcOtcName": "일반의약품",
//      "medicinePermitDate": "20210823",
//      "formCodeName": "필름코팅정",
//      "markCodeFrontAnal": "",
//      "markCodeBackAnal": "",
//      "markCodeFrontImg": "",
//      "markCodeBackImg": "",
//      "changeDate": "20211213",
//      "markCodeFront": null,
//      "markCodeBack": null,
//      "medicineEngName": "Tylenol Tablet 500mg",
//      "ediCode": null
//    },
