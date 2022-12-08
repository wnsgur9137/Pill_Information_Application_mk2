//
//  DirectionViewController.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/31.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SafariServices

final class DirectionViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    var medicineInfo: MedicineInfoItem? = nil
    var medicineInfoList: Array = [[String]]()
    
    var medicineName: String = ""
    var medicineImageURL: String = ""
    var className: String = ""
    var etcOtcName: String = ""
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var starButton: UIBarButtonItem = {
        var barButtonItem = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(starButtonTapped))
        barButtonItem.tintColor = .orange
        return barButtonItem
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "약 이름".localized()
        label.textColor = .label
        label.font = .systemFont(ofSize: 30.0, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var warningTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "필수 지침".localized()
//        label.backgroundColor = .lightGray
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 16.0, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.text = "앱 사용 경고 사항".localized()
        label.textColor = .label
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var linkLabel: UILabel = {
        let label = UILabel()
        label.text = "koreaPharmaceuticalInfoCenter".localized()
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 12.0, weight: .bold)
        
        label.isUserInteractionEnabled = true
        
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(fixedLabelTapped(_:))
        )
        label.addGestureRecognizer(recognizer)
        
        return label
    }()
    
//    private lazy var pillImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.backgroundColor = .systemGray
//        return imageView
//    }()
    
    private lazy var contentTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DetailTableViewImageCell.self, forCellReuseIdentifier: "DetailTableViewImageCell")
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: "DetailTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingView.show()
        self.navigationItem.title = "복용 방법".localized()
        self.navigationItem.rightBarButtonItem = self.starButton
        bind()
        attribute()
        setMedicineInfoList(data: medicineInfo!)
        setupLayout()
        LoadingView.hide()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.contentTableView.reloadData()
        }
    }
}

extension DirectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicineInfoList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewImageCell", for: indexPath) as? DetailTableViewImageCell else { return UITableViewCell() }
            
            let pillImageURL = URL(string: self.medicineImageURL)
            cell.pillImageView.kf.setImage(with: pillImageURL)
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = "\(medicineInfoList[indexPath.row-1][0])"
        cell.contentLabel.text = medicineInfoList[indexPath.row-1][1].replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "")
        return cell
    }
}

private extension DirectionViewController {
    func bind() {
        
    }
    
    func attribute() {
        self.titleLabel.text = medicineInfo?.medicineName
//        self.warningLabel.text = medicineInfo?.efcyQesitm?.replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "")
//        let pillImageURL = URL(string: self.medicineImageURL)
//        self.pillImageView.kf.setImage(with: pillImageURL)
        
        let starList = UserDefaults.standard.array(forKey: "starList") as? [[String]]

        if starList == nil || starList == [] {
            self.starButton.image = UIImage(systemName: "star")
        } else {
            for index in 0..<starList!.count {
                if starList![index][0].contains(medicineName) {
                    self.starButton
                        .image = UIImage(systemName: "star.fill")
                    break
                } else {
                    self.starButton.image = UIImage(systemName: "star")
                }
            }
        }
    }
    
    @objc func starButtonTapped() {
        let medicineName = self.medicineName
        let medicineImage = self.medicineImageURL
        let className = self.className
        let etcOtcname = self.etcOtcName
        var starList = UserDefaults.standard.array(forKey: "starList") as? [[String]]
        
        var starListCheck = false
        
        if starList == nil  || starList == [] {
            UserDefaults.standard.set([[medicineName, medicineImage, className, etcOtcname]], forKey: "starList")
            starList = UserDefaults.standard.array(forKey: "starList") as? [[String]]
            self.starButton.image = UIImage(systemName: "star.fill")
        } else {
            for i in 0..<starList!.count {
                if starList![i][0].contains(medicineName) {
                    starList?.remove(at: i)
                    UserDefaults.standard.set(starList, forKey: "starList")
                    self.starButton.image = UIImage(systemName: "star")
                    starListCheck = true
                    break
//                    if let index = starList![0].firstIndex(of: medicineName) {
//                        starList?.remove(at: index)
//                        UserDefaults.standard.set(starList, forKey: "starList")
//                        self.starButton.image = UIImage(systemName: "star")
//                        starListCheck = true
//                        break
//                    }
                }
            }
            if !starListCheck {
                starList?.append([medicineName, medicineImage, className, etcOtcname])
                UserDefaults.standard.set(starList, forKey: "starList")
                self.starButton.image = UIImage(systemName: "star.fill")
            }
        }
    }
    
    @objc func fixedLabelTapped(_ sender: UITapGestureRecognizer) {
        //fixedLabel에서 UITapGestureRecognizer로 선택된 부분의 CGPoint를 구합니다.
        let point = sender.location(in: linkLabel)
        
        // fixedLabel 내에서 문자열 google이 차지하는 CGRect값을 구해, 그 안에 point가 포함되는지를 판단합니다.
        
        if let koreaRect = linkLabel.boundingRectForCharacterRange(subText: "koreaPharmaceuticalInfoCenter".localized()), koreaRect.contains(point) {
            let alertCon = UIAlertController(
                title: "앱 외부 사이트로 전환".localized(),
                message: nil,
                preferredStyle: UIAlertController.Style.alert
            )
            let alertActYes = UIAlertAction(
                title: "이동".localized(),
                style: UIAlertAction.Style.default,
                handler: { [weak self] _ in
                    self?.present(url: "https://www.health.kr/")
                }
            )
            let alertActNo = UIAlertAction(
                title: "취소".localized(),
                style: UIAlertAction.Style.cancel
            )
            [
                alertActYes,
                alertActNo
            ].forEach{alertCon.addAction($0)}
            self.present(alertCon, animated: true)
        }
    }
    
    func present(url string: String) {
      if let url = URL(string: string) {
        let viewController = SFSafariViewController(url: url)
          self.present(viewController, animated: true)
      }
    }
    
    func setMedicineInfoList(data: MedicineInfoItem) {
        self.medicineInfoList.append(contentsOf: [["제품명".localized(), data.medicineName ?? ""]])
        self.medicineInfoList.append(contentsOf: [["업체명".localized(), data.entpName ?? ""]])
        self.medicineInfoList.append(contentsOf: [["품목기준코드".localized(), data.medicineSeq ?? ""]])
        self.medicineInfoList.append(contentsOf: [["효능".localized(), data.efcyQesitm ?? ""]])
        self.medicineInfoList.append(contentsOf: [["사용법".localized(), data.useMethodQesitm ?? ""]])
        self.medicineInfoList.append(contentsOf: [["주의사항, 경고".localized(), data.atpnWarnQesitm ?? ""]])
        self.medicineInfoList.append(contentsOf: [["주의사항".localized(), data.atpnQesitm ?? ""]])
        self.medicineInfoList.append(contentsOf: [["상호작용".localized(), data.intrcQesitm ?? ""]])
        self.medicineInfoList.append(contentsOf: [["부작용".localized(), data.seQesitm ?? ""]])
        self.medicineInfoList.append(contentsOf: [["보관법".localized(), data.depositMethodQesitm ?? ""]])
        self.medicineInfoList.append(contentsOf: [["공개일자".localized(), data.openDate ?? ""]])
        self.medicineInfoList.append(contentsOf: [["수정일자".localized(), data.updateDate ?? ""]])
        self.medicineInfoList.append(contentsOf: [["낱알 이미지".localized(), data.medicineImage ?? ""]])
    }
    
    func setupLayout() {
        [
            backgroundView,
            titleLabel,
            warningTitleLabel,
            warningLabel,
            linkLabel,
//            pillImageView,
            contentTableView
        ].forEach{ view.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(5.0)
            $0.leading.equalToSuperview().offset(10.0)
            $0.trailing.equalToSuperview().inset(10.0)
        }
        
        warningTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10.0)
            $0.centerX.equalToSuperview()
        }
        
        warningLabel.snp.makeConstraints {
            $0.top.equalTo(warningTitleLabel.snp.bottom).offset(10.0)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing)
        }
        
        linkLabel.snp.makeConstraints {
            $0.top.equalTo(warningLabel.snp.bottom).offset(2.0)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing)
        }
        
//        pillImageView.snp.makeConstraints {
//            $0.top.equalTo(directionLabel.snp.bottom).offset(20.0)
//            $0.leading.equalTo(titleLabel.snp.leading)
//            $0.trailing.equalTo(titleLabel.snp.trailing)
//            $0.height.equalTo(180.0)
//        }
        
        contentTableView.snp.makeConstraints {
            $0.top.equalTo(linkLabel.snp.bottom).offset(20.0)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
