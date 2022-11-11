//
//  ResultTableView.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/11/08.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ResultTableView: UITableView {
    let disposeBag = DisposeBag()
    
    // SearchViewController -> ResultTableView
    let cellData = PublishSubject<[ResultTableViewCellData]>()
    
    let headerView = ResultTableViewHeader(
        frame: CGRect(
            origin: .zero,
            size: CGSize(width: UIScreen.main.bounds.width, height: 50)
            // UIScreen.main.bounds.width = 디바이스의 좌우
        )
    )
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        bind()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ResultTableView {
    func bind() {
        cellData
            .asDriver(onErrorJustReturn: [])
            .drive(self.rx.items) { tv, row, data in
                let index = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: index) as! ResultTableViewCell
                
                cell.setData(data: data)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    func attribute() {
        self.backgroundColor = .systemBackground
        self.register(ResultTableViewCell.self, forCellReuseIdentifier: "ResultTableViewCell")
        self.separatorStyle = .singleLine
        self.rowHeight = 100.0
    }
}
