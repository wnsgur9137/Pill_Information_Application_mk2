//
//  MedicineDataOverview.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/11/09.
//

import Foundation

struct MedicineOverview: Decodable {
    let body: [MedicineBody]
}

struct MedicineBody: Decodable {
    let pageNo: Int?
    let totalCount: Int?
    let numOfRows: Int?
    let items: [MedicineItem]
}

struct MedicineItem: Decodable {
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
    let lenLong: String?
    let lenShort: String?
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
    let updateDate: String?
    let markCodeFront: String?
    let markCodeBack: String?
    let ediCode: String?
    
    enum CodingKeys: String, CodingKey {
        case medicineSeq = "ITEM_SEQ"
        case medicineName = "ITEM_NAME"
        case entpSeq = "ENTP_SEQ"
        case entpName = "ENTP_NAME"
        case chart = "CHART"
        case medicineImage = "ITEM_IMAGE"
        case printFront = "PRINT_FRONT"
        case printBack = "PRINT_BACK"
        case medicineShape = "DRUG_SHAPE"
        case colorClass1 = "COLOR_CLASS1"
        case colorClass2 = "COLOR_CLASS2"
        case lineFront = "LINE_FRONT"
        case lineBack = "LINE_BACK"
        case lenLong = "LENG_LONG"
        case lenShort = "LENG_SHORT"
        case thick = "THICK"
        case imgRegistTs = "IMG_REGIST_TS"
        case classNo = "CLASS_NO"
        case className = "CLASS_NAME"
        case etcOtcName = "ETC_OTC_NAME"
        case medicinePermitDate = "ITEM_PERMIT_DATE"
        case formCodeName = "FORM_CODE_NAME"
        case markCodeFrontAnal = "MARK_CODE_FRONT_ANAL"
        case markCodeBackAnal = "MARK_CODE_BACK_ANAL"
        case markCodeFrontImage = "MARK_CODE_FRONT_IMG"
        case markCodeBackImage = "MARK_CODE_BACK_IMG"
        case medicineEngName = "ITEM_ENG_NAME"
        case updateDate = "CHANGE_DATE"
        case markCodeFront = "MARK_CODE_FRONT"
        case markCodeBack = "MARK_CODE_BACK"
        case ediCode = "EDI_CODE"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.medicineSeq = try? values.decode(String?.self, forKey: .medicineSeq)
        self.medicineName = try? values.decode(String?.self, forKey: .medicineName)
        self.entpSeq = try? values.decode(String?.self, forKey: .entpSeq)
        self.entpName = try? values.decode(String?.self, forKey: .entpName)
        self.chart = try? values.decode(String?.self, forKey: .chart)
        self.medicineImage = try? values.decode(String?.self, forKey: .medicineImage)
        self.printFront = try? values.decode(String?.self, forKey: .printFront)
        self.printBack = try? values.decode(String?.self, forKey: .printBack)
        self.medicineShape = try? values.decode(String?.self, forKey: .medicineShape)
        self.colorClass1 = try? values.decode(String?.self, forKey: .colorClass1)
        self.colorClass2 = try? values.decode(String?.self, forKey: .colorClass2)
        self.lineFront = try? values.decode(String?.self, forKey: .lineFront)
        self.lineBack = try? values.decode(String?.self, forKey: .lineBack)
        self.lenLong = try? values.decode(String?.self, forKey: .lenLong)
        self.lenShort = try? values.decode(String?.self, forKey: .lenShort)
        self.thick = try? values.decode(String?.self, forKey: .thick)
        self.imgRegistTs = try? values.decode(String?.self, forKey: .imgRegistTs)
        self.classNo = try? values.decode(String?.self, forKey: .classNo)
        self.className = try? values.decode(String?.self, forKey: .className)
        self.etcOtcName = try? values.decode(String?.self, forKey: .etcOtcName)
        self.medicinePermitDate = try? values.decode(String?.self, forKey: .medicinePermitDate)
        self.formCodeName = try? values.decode(String?.self, forKey: .formCodeName)
        self.markCodeFrontAnal = try? values.decode(String?.self, forKey: .markCodeFrontAnal)
        self.markCodeBackAnal = try? values.decode(String?.self, forKey: .markCodeBackAnal)
        self.markCodeFrontImage = try? values.decode(String?.self, forKey: .markCodeFrontImage)
        self.markCodeBackImage = try? values.decode(String?.self, forKey: .markCodeBackImage)
        self.medicineEngName = try? values.decode(String?.self, forKey: .medicineEngName)
        self.updateDate = try? values.decode(String?.self, forKey: .updateDate)
        self.markCodeFront = try? values.decode(String?.self, forKey: .markCodeFront)
        self.markCodeBack = try? values.decode(String?.self, forKey: .markCodeBack)
        self.ediCode = try? values.decode(String?.self, forKey: .ediCode)
    }
}

//    ITEM_SEQ": "196500051",
//    "ITEM_NAME": "지엘타이밍정(카페인무수물)",
//    "ENTP_SEQ": "19650018",
//    "ENTP_NAME": "지엘파마(주)",
//    "CHART": "노란색의 팔각형 정제",
//    "ITEM_IMAGE": "https://nedrug.mfds.go.kr/pbp/cmn/itemImageDownload/1NAT_bwbZd9",
//    "PRINT_FRONT": "마크",
//    "PRINT_BACK": "T1E",
//    "DRUG_SHAPE": "팔각형",
//    "COLOR_CLASS1": "노랑",
//    "COLOR_CLASS2": null,
//    "LINE_FRONT": null,
//    "LINE_BACK": null,
//    "LENG_LONG": "7.9",
//    "LENG_SHORT": "7.9",
//    "THICK": "3.9",
//    "IMG_REGIST_TS": "20200603",
//    "CLASS_NO": "01150",
//    "CLASS_NAME": "각성제,흥분제",
//    "ETC_OTC_NAME": "일반의약품",
//    "ITEM_PERMIT_DATE": "19651221",
//    "FORM_CODE_NAME": "나정",
//    "MARK_CODE_FRONT_ANAL": "",
//    "MARK_CODE_BACK_ANAL": "",
//    "MARK_CODE_FRONT_IMG": "",
//    "MARK_CODE_BACK_IMG": "",
//    "ITEM_ENG_NAME": "GL Timing Tab.",
//    "CHANGE_DATE": "20200103",
//    "MARK_CODE_FRONT": null,
//    "MARK_CODE_BACK": null,
//    "EDI_CODE": null
