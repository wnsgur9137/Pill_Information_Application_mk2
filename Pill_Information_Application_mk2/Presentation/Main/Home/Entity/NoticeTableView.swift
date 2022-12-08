//
//  NoticeTableView.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/11/08.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NoticeTableView: UITableView {
    
    let disposeBag = DisposeBag()
    
    let cellData = PublishSubject<[NoticeListOverview]>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        bind()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        cellData
            .asDriver(onErrorJustReturn: [])
            .drive(self.rx.items) { tv, row, data in
                let index = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: "NoticeTableViewCell", for: index) as! NoticeTableViewCell
                
//                cell.setData(data)
                return cell
            }
            .disposed(by: disposeBag)
        
        self.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.deselectRow(at: indexPath, animated: true)
                print("")
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        self.backgroundColor = .systemBackground
        self.register(NoticeTableViewCell.self, forCellReuseIdentifier: "NoticeTableViewCell")
        self.separatorStyle = .singleLine
        self.rowHeight = 100
    }
}
