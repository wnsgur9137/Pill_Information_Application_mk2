//
//  AlarmCell.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/11/21.
//

import UIKit
import UserNotifications

class AlarmCell: UITableViewCell {
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    lazy var meridiemLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    lazy var alarmSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.addTarget(self, action: #selector(alarmSwitchValueChanged), for: .valueChanged)
        return uiSwitch
    }()
    
    lazy var pillNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pillNameLabel.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func alarmSwitchValueChanged(_ sender: UISwitch) {
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
