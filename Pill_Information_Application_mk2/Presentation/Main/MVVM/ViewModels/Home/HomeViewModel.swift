//
//  HomeViewModel.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/12/08.
//

import RxSwift
import RxCocoa

import Alamofire
import SwiftyJSON
import SafariServices

struct HomeViewModel {
    let disposeBag = DisposeBag()

    // ViewModel -> View
    let cellData: Driver<String>
    let push: Driver<NoticeViewModel>

    // View -> ViewModel
    let itemSelected = PublishRelay<Int>()
    let koreaPharmaceuticalInfoCenterButtonTapped = PublishRelay<Void>()
    let getData = PublishRelay<Void>()

//    init(model: HomeModel = HomeModel()) {
//
//        let noticeViewModel = NoticeViewModel()
//        let supportLabel = Observable.just("Support")
//        let supportEmail = Observable.just("wnsgur9137@icloud.com")
//
//        self.push = itemSelected
//            .compactMap { row -> NoticeViewModel? in
//                guard case 1 = row else {
//                    return nil
//                }
//            }
//    }
}
