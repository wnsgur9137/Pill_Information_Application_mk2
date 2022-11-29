//
//  AlarmCell.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/11/21.
//

import UIKit
import UserNotifications
import SnapKit

class AlarmCell: UITableViewCell {
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    lazy var meridiemLabel: UILabel = {
        let label = UILabel()
        label.text = "오전".localized()
        label.font = .systemFont(ofSize: 30.0, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "17:00"
        label.font = .systemFont(ofSize: 40.0, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    lazy var alarmSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.addTarget(self, action: #selector(alarmSwitchValueChanged(sender:)), for: .valueChanged)
        
        return uiSwitch
    }()
    
    lazy var pillNameLabel: UILabel = {
        let label = UILabel()
        label.text = "탁센"
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
        setupLayout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pillNameLabel.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func alarmSwitchValueChanged(sender: UISwitch) {
        guard let data = UserDefaults.standard.value(forKey: "alarms") as? Data,
              var alarms = try? PropertyListDecoder().decode([Alarm].self, from: data) else { return }
        
        alarms[alarmSwitch.tag].isOn = alarmSwitch.isOn
        UserDefaults.standard.set(try? PropertyListEncoder().encode(alarms), forKey: "alarms")
        
        if alarmSwitch.isOn {
            userNotificationCenter.addNotificationRequest(by: alarms[alarmSwitch.tag])
        } else {
            userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [alarms[alarmSwitch.tag].id])
        }
    }
}

private extension AlarmCell {
    func setupLayout() {
        [
            meridiemLabel,
            timeLabel,
            pillNameLabel,
            alarmSwitch
        ].forEach{ addSubview($0) }
        
        meridiemLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10.0)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(meridiemLabel.snp.trailing).offset(10.0)
        }
        
        pillNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(timeLabel.snp.trailing).offset(20.0)
        }
        
        alarmSwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-10.0)
        }
    }
}
