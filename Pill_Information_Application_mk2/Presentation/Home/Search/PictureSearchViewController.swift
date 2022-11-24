//
//  PictureSearchViewController.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/31.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

import AVFoundation
import Photos

final class PictureSearchViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    var medicineShapeList = ["장방형", "원형", "팔각형", "타원형", "육각형", "반원형", "삼각형", "오각형", "마름모형", "기타"]
    var medicineColorList = ["하양", "빨강", "분홍", "자주", "주황", "갈색", "노랑", "연두", "초록", "청록", "파랑", "남색", "보라", "회색", "검정", "투명"]
    var medicineLineList = ["없음", "-", "+", "기타"]
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        return imagePickerController
    }()
    
    private lazy var pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Pill_Image")
        return imageView
    }()
    
    private lazy var choiceImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("사진 선택", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private lazy var shapeLabel: UILabel = {
        let label = UILabel()
        label.text = "의약품 모양"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var shapeTextField: UITextField = {
        let textField = UITextField()
        textField.inputView = medicineShapePicker
        textField.text = medicineShapeList[0]
        return textField
    }()
    
    private lazy var medicineShapePicker: UIPickerView = {
        let pickerview = UIPickerView()
        pickerview.delegate = self
        pickerview.dataSource = self
        return pickerview
    }()
    
    private lazy var colorLabel: UILabel = {
        let label = UILabel()
        label.text = "색상"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var colorTextField: UITextField = {
        let textField = UITextField()
        textField.inputView = medicineColorPicker
        textField.text = medicineColorList[0]
        return textField
    }()
    
    private lazy var medicineColorPicker: UIPickerView = {
        let pickerview = UIPickerView()
        pickerview.delegate = self
        pickerview.dataSource = self
        return pickerview
    }()
    
    private lazy var lineLabel: UILabel = {
        let label = UILabel()
        label.text = "분할선"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var lineTextField: UITextField = {
        let textField = UITextField()
        textField.inputView = medicineLinePicker
        textField.text = medicineLineList[0]
        return textField
    }()
    
    private lazy var medicineLinePicker: UIPickerView = {
        let pickerview = UIPickerView()
        pickerview.delegate = self
        pickerview.dataSource = self
        return pickerview
    }()
    
    private lazy var markCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "마크 코드"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var markCodeTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("검색", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private lazy var textFieldStackView: UIStackView = {
        let shapeStackView = UIStackView(arrangedSubviews: [shapeLabel, shapeTextField])
        shapeStackView.axis = .horizontal
        shapeStackView.distribution = .fill
        shapeStackView.spacing = 10.0
        
        let colorStackView = UIStackView(arrangedSubviews: [colorLabel, colorTextField])
        colorStackView.axis = .horizontal
        colorStackView.distribution = .fill
        colorStackView.spacing = 10.0
        
        let lineStackView = UIStackView(arrangedSubviews: [lineLabel, lineTextField])
        lineStackView.axis = .horizontal
        lineStackView.distribution = .fill
        lineStackView.spacing = 10.0
        
        let markCodeStackView = UIStackView(arrangedSubviews: [markCodeLabel, markCodeTextField])
        markCodeStackView.axis = .horizontal
        markCodeStackView.distribution = .fill
        markCodeStackView.spacing = 10.0
        
        
        let stackView = UIStackView(arrangedSubviews: [
            shapeStackView,
            colorStackView,
            lineStackView,
            markCodeStackView
        ])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10.0
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "알약 모양으로 검색"
        bind()
        setupLayout()
        keyboardAtrribute()
//        choiceImageButtonTapped()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func keyboardAtrribute() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
}

extension PictureSearchViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == medicineShapePicker {
            return medicineShapeList.count
        } else if pickerView == medicineColorPicker {
            return medicineColorList.count
        } else if pickerView == medicineLinePicker {
            return medicineLineList.count
        } else {
            return 0
        }
    }
    
    // pickerview 내 선택지의 값들을 원하는 데이터로 채워준다.
   func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       if pickerView == medicineShapePicker {
           return medicineShapeList[row]
       } else if pickerView == medicineColorPicker {
           return medicineColorList[row]
       } else if pickerView == medicineLinePicker {
           return medicineLineList[row]
       } else {
           return ""
       }
   }
   // textfield의 텍스트에 pickerview에서 선택한 값을 넣어준다.
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       if pickerView == medicineShapePicker {
           self.shapeTextField.text = self.medicineShapeList[row]
       } else if pickerView == medicineColorPicker {
           self.colorTextField.text = self.medicineColorList[row]
       } else if pickerView == medicineLinePicker {
           self.lineTextField.text = self.medicineLineList[row]
       }
   }
}

extension PictureSearchViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            pictureImageView.image = image
//            recognitionText(image: image)
        }

        // 비디오인 경우
//        guard let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {
//            picker.dismiss(animated: true, completion: nil)
//            return
//        }
//        let video = AVAsset(url: url)
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}


private extension PictureSearchViewController {
    func bind() {
        choiceImageButton.rx.tap
            .bind(onNext: { [weak self] in
//                self?.choiceImageButtonTapped()
                self?.actionLibrary()
            })
            .disposed(by: disposeBag)
        
        searchButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                let vc = ResultViewController()
//                vc.searchMedicineData = [
//                    "shape": self.shapeTextField.text ?? "",
//                    "color": self.colorTextField.text ?? "",
//                    "line": self.lineTextField.text ?? "",
//                    "markcode": self.markCodeTextField.text ?? ""
//                ]
                let shape = self.shapeTextField.text ?? ""
                let color = self.colorTextField.text ?? ""
                var line = ""
                if self.lineTextField.text! == "-" {
                    line = "실선"
                } else if self.lineTextField.text! == "+" {
                    line = "십자"
                }
                var markCode = self.markCodeTextField.text ?? ""
                if markCode == "" {
                    markCode = "nil"
                }
                vc.searchMedicineData = [
                    shape,
                    color,
                    line,
                    markCode
                ]
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func choiceImageButtonTapped() {
        let alert = UIAlertController(title: "사진으로 검색", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "사진 촬영", style: .default) { (action) in
            self.actionCamera()
        }
        let libraryAction = UIAlertAction(title: "갤러리 사진 선택", style: .default) { (action) in
            self.actionLibrary()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)

        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func actionCamera() {
//        #if targetEnvironment(simulator)
//        fatalError()
//        #endif
        
        switch PHPhotoLibrary.authorizationStatus() {
        case .denied:
            self.showAlertGoToSetting()
        case .restricted:
            break
        case .authorized:
            self.imagePickerController.sourceType = .camera
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.cameraFlashMode = .auto
            self.present(self.imagePickerController, animated: true, completion: nil)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ state in
                if state == .authorized {
                    DispatchQueue.main.async {
                        self.imagePickerController.sourceType = .camera
                        self.imagePickerController.allowsEditing = true
                        self.imagePickerController.cameraFlashMode = .auto
                        self.present(self.imagePickerController, animated: true, completion: nil)
                    }
                } else {
                    self.imagePickerController.dismiss(animated: true, completion: nil)
                }
            })
        default:
            break
        }
        
//        AVCaptureDevice.requestAccess(for: .video) { [weak self] isAuthorized in
//            guard let self = self else { return }
//            guard isAuthorized else {
//                self.showAlertGoToSetting()
//                return
//            }
//
//            // 카메라 열기
//            DispatchQueue.main.async {
//                let pickerController = UIImagePickerController()
//                pickerController.sourceType = .camera
//                pickerController.allowsEditing = false
//                pickerController.mediaTypes = ["public.image"]
//                // 비디오를 사용할 경우 (이 프로젝트에선 크게 필요 없음)
////                pickerController.mediaTypes = ["public.movie"]
////                pickerController.videoQuality = .typeHigh
//                pickerController.delegate = self
//                self.present(pickerController, animated: true)
//            }
//        }
    }
    
    func showAlertGoToSetting() {
        let alertCon = UIAlertController(
            title: "현재 카메라 사용에 대한 접근 권한이 없습니다.",
            message: "설정 -> {앱 이름}탭에서 접근을 활성화 할 수 있습니다.",
            preferredStyle: .alert
        )
        let cancelAct = UIAlertAction(
            title: "취소",
            style: .cancel
        ) { _ in
            alertCon.dismiss(animated: true, completion: nil)
        }
        let gotoSettingAct = UIAlertAction(
            title: "설정으로 이동하기",
            style: .default
        ) { _ in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingURL) else { return }
            UIApplication.shared.open(settingURL, options: [:])
        }
        
        [cancelAct, gotoSettingAct].forEach(alertCon.addAction(_:))
        DispatchQueue.main.async {
            self.present(alertCon, animated: true)
        }
    }
    
    func actionLibrary() {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    func setupLayout() {
        [
            backgroundView,
            pictureImageView,
//            choiceImageButton,
            textFieldStackView,
            searchButton
        ].forEach{ view.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        pictureImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(240.0)
            $0.height.equalTo(240.0)
        }
        
//        choiceImageButton.snp.makeConstraints {
//            $0.top.equalTo(pictureImageView.snp.bottom).offset(10.0)
//            $0.centerX.equalToSuperview()
//        }
        
        textFieldStackView.snp.makeConstraints {
            $0.top.equalTo(pictureImageView.snp.bottom).offset(50.0)
            $0.leading.equalToSuperview().offset(10.0)
            $0.trailing.equalToSuperview().inset(10.0)
            
            [shapeLabel, colorLabel, lineLabel, markCodeLabel].forEach {
                $0.snp.makeConstraints {
                    $0.width.equalTo(100.0)
                    $0.height.equalTo(34.0)
                }
            }
            
        }
        
        searchButton.snp.makeConstraints {
            $0.top.equalTo(textFieldStackView.snp.bottom).offset(50.0)
            $0.centerX.equalToSuperview()
        }
        
        
    }
}
