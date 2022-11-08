//
//  AlarmViewController.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AlarmViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "알람"
        label.textColor = .label
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var timerBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "타이머", style: UIBarButtonItem.Style.plain, target: self, action: #selector(timerBarButtonItemTapped))
        return barButtonItem
    }()
    
    private lazy var alramBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "알람 추가", style: UIBarButtonItem.Style.plain, target: self, action: #selector(alramBarButtonItemTapped))
        return barButtonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        attribute()
        setupLayout()
    }
}

extension AlarmViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

private extension AlarmViewController {
    func bind() {
        
    }
    
    @objc func timerBarButtonItemTapped() {
        let vc = TimerViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func alramBarButtonItemTapped() {
        let vc = AddAlarmViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func attribute() {
        self.navigationItem.title = "알람"
        self.navigationItem.leftBarButtonItem = timerBarButtonItem
        self.navigationItem.rightBarButtonItem = alramBarButtonItem
    }
    
    func setupLayout() {
        [
            backgroundView,
            titleLabel,
            tableView
        ].forEach{ view.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
