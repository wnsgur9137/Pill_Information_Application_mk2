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

import AudioToolbox
import UserNotifications

enum TimerStatus {
    case start  // 시작
    case pause  // 정지
    case end   // 종료
}

final class TimerViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    var duration = 60 // 타이머의 설정된 시간을 초(sec)로 저장하는 프로퍼티. 60초로 초기화한 이유 : 앱이 실행되면 데이터 피커가 기본적으로 1분으로 설정되어 있기 때문.
    var timerStatus: TimerStatus = .end  // 타이머의 상태를 가지고 있는 프로퍼티.
    var timer: DispatchSourceTimer?
    var currentSeconds = 0  // 현재 카운트다운 되고 있는 시간을 초(sec)로 저장하는 프로퍼티
    
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
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        return label
    }()
    
    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView()
        return progress
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        return button
    }()
    
    private lazy var toggleButton: UIButton = {
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
        self.configureToggle()
    }
}

//extension TimerViewController: UIDatePicker {
//
//}

private extension TimerViewController {
    func bind() {
        cancelButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.cancelButtonTapped()
            })
            .disposed(by: disposeBag)
        
        toggleButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.toggleButtonTapped()
            })
            .disposed(by: disposeBag)
        
    }
    
    func setTimerInfoViewVisble(isHidden: Bool) {
        self.timerLabel.isHidden = isHidden
        self.progressView.isHidden = isHidden
    }
    
    func configureToggle() {
        self.timerLabel.alpha = 0
        self.progressView.alpha = 0
        self.datePicker.alpha = 1
        self.toggleButton.setTitle("시작", for: .normal)  // 버튼의 초기 상태, 즉 normal 상태일 때 버튼의 타이틀이 시작이고
        self.toggleButton.setTitle("일시정지", for: .selected)  // 버튼이 선택된 상태 (selected) 일 땐 버튼의 타이틀이 일시정지
    }
    
    func startTimer() {  // 타이머를 설정하고, 타이머가 시작되게 하는 메서드
        if self.timer == nil {  // tiemr가 nil이면 타이머를 설정해 줄 것임.
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            self.timer?.schedule(deadline: .now(), repeating: 1)  // 어떤 주기로 타이머를 실행할 것인지 설정. 타이머가 시작되면 즉시 실행되게, 1초마다 반복되도록 설정.
            self.timer?.setEventHandler(handler: { [weak self] in  // 타이머가 동작할 때마다 핸들러 클로저 함수가 호출됨. 1초에 한 번씩 호출됨.
                guard let self = self else { return }
                self.currentSeconds -= 1
                let hour = self.currentSeconds / 3600
                let minutes = (self.currentSeconds % 3600) / 60
                let seconds = (self.currentSeconds % 3600) % 60
                self.timerLabel.text = String(format: "%02d:%02d:%02d", hour, minutes, seconds)
                self.progressView.progress = Float(self.currentSeconds) / Float(self.duration)
                
                // 빙글빙글
                UIView.animate(withDuration: 0.5, delay: 0, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
                })
                UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: .pi * 2)
                })
                
                if self.currentSeconds <= 0 {
                    self.stopTimer()
                    AudioServicesPlaySystemSound(1005)
                    self.messageAlert(controllerTitle: "타이머가 종료되었어요!", controllerMessage: "약은 꼭 생수와 먹읍시다!", actionTitle: "확인")
                }
            })
            self.timer?.resume()
        }
    }
    
    /// Alert 출력
    func messageAlert(controllerTitle:String, controllerMessage:String, actionTitle:String) {
        let alertCon = UIAlertController(title: controllerTitle, message: controllerMessage, preferredStyle: UIAlertController.Style.alert)
        let alertAct = UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default)
        alertCon.addAction(alertAct)
        present(alertCon, animated: true, completion: nil)
    }
    
    func stopTimer() {
        if self.timerStatus == .pause {
            self.timer?.resume()
        }
        self.timerStatus = .end
        self.cancelButton.isEnabled = false
        //self.setTimerInfoViewVisble(isHidden: true)
        //self.datePicker.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.timerLabel.alpha = 0
            self.progressView.alpha = 0
            self.datePicker.alpha = 1
            self.imageView.transform = .identity
        })
        self.toggleButton.isSelected = false
        self.timer?.cancel()
        self.timer = nil  // 메모리 해제. 타이머를 종료할 때 꼭 해야 함. 안 해 주면 화면 꺼도 타이머 돌아간다...
        
    }
        
    func cancelButtonTapped() {
        switch self.timerStatus
        {
        case .start, .pause :
            self.stopTimer()  // 타이머 종료
            
        default :
            break
        }
        
    }
    
    func toggleButtonTapped() {
        self.duration = Int(self.datePicker.countDownDuration)  // countDwonDuration 프로퍼티는 데이터피커에서 설정한 시간이 몇 초인지 알려줌. 만약, 2분이라고 설정했다면, 120초라고 알려 주는 것임.
        
        switch self.timerStatus
        {
        case .end :  // end이면 시작 버튼을 눌러서 타이머가 시작된 상태일 테니...
            self.currentSeconds = self.duration
            self.timerStatus = .start
            // self.setTimerInfoViewVisble(isHidden: false)
            // self.datePicker.isHidden = true
            UIView.animate(withDuration: 0.5, animations: {
                self.timerLabel.alpha = 1
                self.progressView.alpha = 1
                self.datePicker.alpha = 0
            })
            self.toggleButton.isSelected = true
            self.cancelButton.isEnabled = true
            self.startTimer()
            
        case .start :  // start이면 타이머가 시작된 상태, 즉 toggleButton의 타이틀이 "일시정지"일 때 toggleButton을 누르는 것이니...
            self.timerStatus = .pause
            self.toggleButton.isSelected = false
            self.timer?.suspend()  // 타이머 일시정지 시켜 줌
            
        case .pause :  // 타이머가 일시정지인 상태에서 다시 toggleButton을 누르면 타이머가 재시작되니까
            self.timerStatus = .start
            self.toggleButton.isSelected = true
            self.timer?.resume()
            
//        default :
//            break
        }
    }
    
    func setupLayout() {
        [
            backgroundView,
            imageView,
            datePicker,
            timerLabel,
            progressView,
            cancelButton,
            toggleButton,
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
        
        timerLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(60.0)
            $0.centerX.equalToSuperview()
        }
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(timerLabel.snp.bottom).offset(20.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300.0)
            $0.height.equalTo(20.0)
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(30.0)
            $0.leading.equalToSuperview().offset(90.0)
            $0.width.equalTo(100.0)
        }
        
        toggleButton.snp.makeConstraints {
            $0.top.equalTo(cancelButton.snp.top)
            $0.trailing.equalToSuperview().inset(90.0)
            $0.width.equalTo(100.0)
        }
        
//        pauseButton.snp.makeConstraints {
//            $0.top.equalTo(cancelButton.snp.top)
//            $0.leading.equalTo(cancelButton.snp.leading)
//            $0.width.equalTo(100.0)
//        }
        
        footerImageView.snp.makeConstraints {
            $0.top.equalTo(cancelButton.snp.bottom).offset(50.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300.0)
            $0.height.equalTo(100.0)
        }
    }
}
