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
        label.text = "약 이름"
        label.textColor = .label
        label.font = .systemFont(ofSize: 30.0, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var directionLabel: UILabel = {
        let label = UILabel()
        label.text = "해열제"
        label.textColor = .label
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var pillImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray
        return imageView
    }()
    
    private lazy var contentTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: "DetailTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingView.show()
        self.navigationItem.title = "복용 방법"
        self.navigationItem.rightBarButtonItem = self.starButton
        bind()
        attribute()
        setMedicineInfoList(data: medicineInfo!)
        setupLayout()
        LoadingView.hide()
    }
}

extension DirectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicineInfoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell else { return UITableViewCell() }
        
        print("indexPath.row : \(medicineInfoList[indexPath.row])")
        cell.titleLabel.text = "\(medicineInfoList[indexPath.row][0])"
        cell.contentLabel.text = medicineInfoList[indexPath.row][1].replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("123")
    }
    
    
}

private extension DirectionViewController {
    func bind() {
        
    }
    
    func attribute() {
        self.titleLabel.text = medicineInfo?.medicineName
        self.directionLabel.text = medicineInfo?.efcyQesitm?.replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "")
        let pillImageURL = URL(string: self.medicineImageURL)
        self.pillImageView.kf.setImage(with: pillImageURL)
        
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
    
    func setMedicineInfoList(data: MedicineInfoItem) {
        self.medicineInfoList.append(contentsOf: [["제품명", data.medicineName ?? ""]])
        self.medicineInfoList.append(contentsOf: [["업체명", data.entpName ?? ""]])
        self.medicineInfoList.append(contentsOf: [["품목기준코드", data.medicineSeq ?? ""]])
        self.medicineInfoList.append(contentsOf: [["효능", data.efcyQesitm ?? ""]])
        self.medicineInfoList.append(contentsOf: [["사용법", data.useMethodQesitm ?? ""]])
        self.medicineInfoList.append(contentsOf: [["주의사항, 경고", data.atpnWarnQesitm ?? ""]])
        self.medicineInfoList.append(contentsOf: [["주의사항", data.atpnQesitm ?? ""]])
        self.medicineInfoList.append(contentsOf: [["상호작용", data.intrcQesitm ?? ""]])
        self.medicineInfoList.append(contentsOf: [["부작용", data.seQesitm ?? ""]])
        self.medicineInfoList.append(contentsOf: [["보관법", data.depositMethodQesitm ?? ""]])
        self.medicineInfoList.append(contentsOf: [["공개일자", data.openDate ?? ""]])
        self.medicineInfoList.append(contentsOf: [["수정일자", data.updateDate ?? ""]])
        self.medicineInfoList.append(contentsOf: [["낱알 이미지", data.medicineImage ?? ""]])
    }
    
    func setupLayout() {
        [
            backgroundView,
            titleLabel,
            directionLabel,
            pillImageView,
            contentTableView
        ].forEach{ view.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20.0)
            $0.leading.equalToSuperview().offset(10.0)
            $0.trailing.equalToSuperview().inset(10.0)
        }
        
        directionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10.0)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing)
        }
        
        pillImageView.snp.makeConstraints {
            $0.top.equalTo(directionLabel.snp.bottom).offset(20.0)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing)
            $0.height.equalTo(180.0)
        }
        
        contentTableView.snp.makeConstraints {
            $0.top.equalTo(pillImageView.snp.bottom).offset(50.0)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}