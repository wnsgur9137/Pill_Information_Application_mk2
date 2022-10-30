//
//  TiemrViewController.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TimerViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Pill_Image")
        return imageView
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .countDownTimer
        datePicker.minuteInterval = 1
        return datePicker
    }()
    
    private lazy var stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        return button
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private lazy var pauseButton: UIButton = {
        let button = UIButton()
        button.setTitle("일시 정지", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        return button
    }()
    
    private lazy var footerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo_Cloud")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "타이머"
        bind()
        setupLayout()
    }
}

//extension TimerViewController: UIDatePicker {
//
//}

private extension TimerViewController {
    func bind() {
        
    }
    
    func setupLayout() {
        [
            backgroundView,
            imageView,
            datePicker,
            stopButton,
            startButton,
            pauseButton,
            footerImageView
        ].forEach{ view.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50.0)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100.0)
        }
        
        datePicker.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(30.0)
            $0.leading.equalToSuperview().offset(10.0)
            $0.trailing.equalToSuperview().inset(10.0)
            $0.height.equalTo(220.0)
        }
        
        stopButton.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(30.0)
            $0.leading.equalToSuperview().offset(90.0)
            $0.width.equalTo(100.0)
        }
        
        startButton.snp.makeConstraints {
            $0.top.equalTo(stopButton.snp.top)
            $0.trailing.equalToSuperview().inset(90.0)
            $0.width.equalTo(100.0)
        }
        
        pauseButton.snp.makeConstraints {
            $0.top.equalTo(stopButton.snp.top)
            $0.leading.equalTo(stopButton.snp.leading)
            $0.width.equalTo(100.0)
        }
        
        footerImageView.snp.makeConstraints {
            $0.top.equalTo(stopButton.snp.bottom).offset(50.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300.0)
            $0.height.equalTo(100.0)
        }
    }
}
