//
//  AddNoticeViewModel.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/12/10.
//

import RxSwift
import RxCocoa
import Alamofire

struct AddNoticeViewModel {
    
    // View -> ViewModel
    let addButtonTapped = PublishRelay<Void>()
    
    // ViewModel -> View
    let presentAlert: Signal<Alert>
    
//    init(model: NoticeModel = NoticeModel()) {
//        self.presentAlert = addButtonTapped
//                .bind(onNext: { [weak self] in
//                    guard let self = self else { return }
//                    let urlTitle = (self.titleTextField.text ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//                    let urlWriter = (UserDefaults.standard.string(forKey: "nickname")!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//                    let urlContent = (self.contentTextView.text ?? "").replacingOccurrences(of: "\n", with: "%5Cn").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//    
//                    let param = "?title=\(urlTitle)&writer=\(urlWriter)&content=\(urlContent)"
//    
//    //                let url = "\(FastAPI.host + FastAPI.path)/setNotice/\(param)"
//                    let url = "\(ubuntuServer.host + ubuntuServer.path)/setNotice/\(param)"
//    
//                    AF.request(url, method: .post)
//                        .response(completionHandler: { response in
//                            switch response.result {
//                            case let .success(data):
//                                print("success: \(String(describing: data))")
//                                let alertCon = UIAlertController(title: "성공".localized(), message: "공지사항 작성 완료".localized(), preferredStyle: UIAlertController.Style.alert)
//                                let alertAct = UIAlertAction(title: "확인".localized(), style: UIAlertAction.Style.default, handler: { _ in
//                                    self.dismiss(animated: true)
//                                })
//                                alertCon.addAction(alertAct)
//                                self.present(alertCon, animated: true, completion: nil)
//                            case let .failure(error):
//                                print("failure: \(error)")
//                                let alertCon = UIAlertController(title: "오류".localized(), message: "공지사항 작성에 실패하였습니다.".localized(), preferredStyle: UIAlertController.Style.alert)
//                                let alertAct = UIAlertAction(title: "확인".localized(), style: UIAlertAction.Style.default)
//                                alertCon.addAction(alertAct)
//                                self.present(alertCon, animated: true)
//                            }
//                        })
//    
//                    print(url)
//                    print("param: \(param)")
//    
//                })
//    }
}
