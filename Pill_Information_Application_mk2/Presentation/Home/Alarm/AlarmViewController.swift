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
    var alarms: [Alarm] = []
    let userNotificationCenter = UNUserNotificationCenter.current()
    
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
        tableView.register(AlarmCell.self, forCellReuseIdentifier: "AlarmCell")
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        alarms = alarmList()
    }
}

extension AlarmViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "💊 약 먹을 시간"
        default :
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as? AlarmCell else { return UITableViewCell() }
        cell.alarmSwitch.isOn = alarms[indexPath.row].isOn
        cell.timeLabel.text = alarms[indexPath.row].time
        cell.meridiemLabel.text = alarms[indexPath.row].meridiem
        cell.pillNameLabel.text = alarms[indexPath.row].pillName
        cell.alarmSwitch.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete :
            userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [alarms[indexPath.row].id])
            self.alarms.remove(at: indexPath.row)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alarms), forKey: "alarms")
            
            self.tableView.reloadData()
            return
            
        default :
            break
        }
    }
    
    // cell 선택 시 시간 및 약 이름 변경하는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addAlarmViewController = AddAlarmViewController()
        addAlarmViewController.pickedDate = { [weak self] date in
            guard let self = self else { return }
            let pillName = addAlarmViewController.pillNameTextField.text
            var alarmList = self.alarmList()
            let newAlarm = Alarm(date: date, isOn: true, pillName: pillName ?? "")
            alarmList.remove(at: indexPath.row)
            alarmList.append(newAlarm)
            alarmList.sort {$0.date < $1.date}
            self.alarms = alarmList
            //UserDefaults에 저장
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alarms), forKey: "alarms")
            self.userNotificationCenter.addNotificationRequest(by: newAlarm)
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(addAlarmViewController, animated: true)
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
        let addAlarmViewController = AddAlarmViewController()
        addAlarmViewController.pickedDate = { [weak self] date in
            guard let self = self else { return }
            let pillName = addAlarmViewController.pillNameTextField.text
            var alarmList = self.alarmList()
            let newAlarm = Alarm(date: date, isOn: true, pillName: pillName ?? "")
            alarmList.append(newAlarm)
            alarmList.sort {$0.date < $1.date}  // 시간 순으로 정렬
            self.alarms = alarmList
            //UserDefaults에 저장
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alarms), forKey: "alarms")
            self.userNotificationCenter.addNotificationRequest(by: newAlarm)
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(addAlarmViewController, animated: true)
    }
    
    func alarmList() -> [Alarm] {
        guard let data = UserDefaults.standard.value(forKey: "alarms") as? Data,
              let alarms = try? PropertyListDecoder().decode([Alarm].self, from: data) else {
            return []
        }
        return alarms
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
