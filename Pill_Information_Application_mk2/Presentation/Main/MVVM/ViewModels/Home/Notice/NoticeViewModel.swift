//
//  NoticeViewModel.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/12/12.
//

import RxSwift
import RxCocoa

struct NoticeViewModel {
    let disposeBag = DisposeBag()
    
    // ViewModel -> View
    let cellData: Driver<[Notice]>
    
    // pop
    // View -> ViewModel
    let pop: Signal<Void>
    
    // 선택된 카테고리가 무엇인지 row값을 받는다.
    // ViewModel -> ParentsViewModel
    let itemSelected = PublishRelay<Int>()
    
//    init() {
////        self.cellData = Driver.just(
//    }
}
