//
//  AddAlarmViewController.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AddAlarmViewController: UIViewController {
    let disposeBag = DisposeBag()
    var pickedDate: ((_ date: Date) -> Void)?
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo_Eng")
        return imageView
    }()
    
    private lazy var pillNameLabel: UILabel = {
        let label = UILabel()
        label.text = "먹을 약 이름:"
        label.textColor = .label
        label.font = .systemFont(ofSize: 17.0, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    lazy var pillNameTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        return textField
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = 1
        datePicker.locale = Locale(identifier: "ko_KR")
        return datePicker
    }()
    
    private lazy var setAlramButton: UIButton = {
        let button = UIButton()
        button.setTitle("알람 설정", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(setAlramButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var pillStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pillNameLabel, pillNameTextField])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10.0
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "알람 설정"
        
        bind()
        setupLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension AddAlarmViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

private extension AddAlarmViewController {
    func bind() {
        
    }
    
    @objc func setAlramButtonTapped() {
        pickedDate?(datePicker.date)
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupLayout() {
        [
            backgroundView,
            imageView,
            pillStackView,
            datePicker,
            setAlramButton
        ].forEach{ view.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(214.0)
            $0.height.equalTo(100.0)
        }
        
        pillStackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(30.0)
            $0.leading.equalToSuperview().offset(10.0)
            $0.trailing.equalToSuperview().inset(10.0)
            $0.height.equalTo(34.0)
            
            pillNameLabel.snp.makeConstraints {
                $0.width.equalTo(130.0)
            }
        }
        
        datePicker.snp.makeConstraints {
            $0.top.equalTo(pillStackView.snp.bottom).offset(50.0)
            $0.leading.equalToSuperview().offset(10.0)
            $0.trailing.equalToSuperview().inset(10.0)
            $0.height.equalTo(220.0)
        }
        
        setAlramButton.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(50.0)
            $0.centerX.equalToSuperview()
        }
    }
}
