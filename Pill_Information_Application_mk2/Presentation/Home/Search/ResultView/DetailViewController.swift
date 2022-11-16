//
//  DetailViewController.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/31.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

import Kingfisher
import Alamofire

final class DetailViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    var medicine: MedicineItem? = nil
    var medicineList: Array = [[String]]()
    var medicineInfoCheck = false
    var medicineInfo: MedicineInfoItem? = nil
    
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
    
    private lazy var classLabel: UILabel = {
        let label = UILabel()
        label.text = "해열제"
        label.textColor = .label
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var directionButton: UIButton = {
        let button = UIButton()
        button.setTitle("복용 방법", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
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
        self.navigationItem.title = "알약 정보"
        self.navigationItem.rightBarButtonItem = self.starButton
        bind()
        setData(data: medicine!)
        LoadingView.show()
        self.getMedicineInfoData(completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(result):
                print("----success----")
                self.medicineInfo = result.body.items[0]
                self.medicineInfoCheck = true
                self.medicineInfoAttribute()
            case .failure(_):
                print("----failure----")
                self.medicineInfoCheck = false
                self.medicineInfoAttribute()
            }
        })
        setupLayout()
        LoadingView.hide()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        attribute()
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicineList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell else { return UITableViewCell() }
        
        print("indexPath.row : \(medicineList[indexPath.row])")
        cell.titleLabel.text = "\(medicineList[indexPath.row][0])"
        cell.contentLabel.text = medicineList[indexPath.row][1]
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50.0
//    }
}

private extension DetailViewController {
    func bind() {
        directionButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                print("directionButton is Tapped")
                let vc = DirectionViewController()
                
                vc.medicineImageURL = (self.medicine?.medicineImage) ?? ""
                vc.medicineInfo = self.medicineInfo
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func medicineInfoAttribute() {
        print("medicineInfoCheck: \(medicineInfoCheck)")
        directionButton.isEnabled = medicineInfoCheck
        if !medicineInfoCheck {
            directionButton.setTitleColor(.systemGray, for: .normal)
        } else {
            directionButton.setTitleColor(.systemBlue, for: .normal)
        }
    }
    
    func attribute() {
        // TEST CODE
//        UserDefaults.standard.removeObject(forKey: "starList")
        
        let starList = UserDefaults.standard.array(forKey: "starList") as? [String]

        if starList != nil {
            if starList!.contains(medicine!.medicineName!) {
                self.starButton
                    .image = UIImage(systemName: "star.fill")
            } else {
                self.starButton.image = UIImage(systemName: "star")
            }
        } else {
            self.starButton.image = UIImage(systemName: "star")
        }
    }
    
    @objc func starButtonTapped() {
        let medicineName = self.medicine?.medicineName ?? ""
        var starList = UserDefaults.standard.array(forKey: "starList") as? [String]
        
        if starList == nil {
            UserDefaults.standard.set([medicineName], forKey: "starList")
            starList = UserDefaults.standard.array(forKey: "starList") as? [String]
            self.starButton.image = UIImage(systemName: "star.fill")
        } else if let index = starList!.firstIndex(of: medicineName) {
            starList?.remove(at: index)
            UserDefaults.standard.set(starList, forKey: "starList")
            self.starButton.image = UIImage(systemName: "star")
        } else {
            starList?.append(medicineName)
            UserDefaults.standard.set(starList, forKey: "starList")
            self.starButton.image = UIImage(systemName: "star.fill")
        }
    }
    
    func setData(data: MedicineItem) {
        setMedicineList(data: data)
        let pillImageURL = URL(string: data.medicineImage ?? "")
        pillImageView.kf.setImage(with: pillImageURL)
        titleLabel.text = data.medicineName
        classLabel.text = data.className
    }
    
    func getMedicineInfoData(completionHandler: @escaping (Result<MedicineInfoOverview, Error>) -> Void) {
//        let url = "\(MedicineInfoAPI.scheme)://\(MedicineInfoAPI.host + MedicineInfoAPI.path)"
        let url = "\(MedicineInfoAPI.scheme)://\(MedicineInfoAPI.host + MedicineInfoAPI.path)?serviceKey=\(MedicineInfoAPI.apiKeyEncoding)&itemName=\(String(describing: medicine!.medicineName!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!))&type=json"
        
        let param = [
            "serviceKey": MedicineInfoAPI.apiKeyEncoding,
            "itemName": medicine!.medicineName!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
            "type": "json"
        ]
        
        print("url: \(url)")
        print("param: \(param)")
        
        AF.request(url, method: .get)
            .response(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    print("success: \(String(describing: data))")
                    do {
                        let medicineInfoData = try JSONDecoder().decode(MedicineInfoOverview.self, from: data!)
                        completionHandler(.success(medicineInfoData))
                    } catch {
                        print("jsonError: \(error)")
                        completionHandler(.failure(error))
                    }
                case let .failure(error):
                    print("failure: \(error)")
                    completionHandler(.failure(error))
                }
            })
    }
    
    func setMedicineList(data: MedicineItem) {
        self.medicineList.append(contentsOf: [["일련번호", data.medicineSeq ?? ""]])
        self.medicineList.append(contentsOf: [["약명", data.medicineName ?? ""]])
        self.medicineList.append(contentsOf: [["제품 영문명", data.medicineEngName ?? ""]])
        self.medicineList.append(contentsOf: [["분류번호", data.classNo ?? ""]])
        self.medicineList.append(contentsOf: [["분류명", data.className ?? ""]])
        self.medicineList.append(contentsOf: [["전문/일반", data.etcOtcName ?? ""]])
        self.medicineList.append(contentsOf: [["제약회사 일련번호", data.entpSeq ?? ""]])
        self.medicineList.append(contentsOf: [["제약회사명", data.entpName ?? ""]])
        self.medicineList.append(contentsOf: [["성상", data.chart ?? ""]])
        self.medicineList.append(contentsOf: [["앞면 모양", data.printFront ?? ""]])
        self.medicineList.append(contentsOf: [["뒷면 모양", data.printBack ?? ""]])
        self.medicineList.append(contentsOf: [["의약품 모양", data.medicineShape ?? ""]])
        self.medicineList.append(contentsOf: [["앞면 색상", data.colorClass1 ?? ""]])
        self.medicineList.append(contentsOf: [["뒷면 색상", data.colorClass2 ?? ""]])
        self.medicineList.append(contentsOf: [["앞면 분할선", data.lineFront ?? ""]])
        self.medicineList.append(contentsOf: [["뒷면 분할선", data.lineBack ?? ""]])
        self.medicineList.append(contentsOf: [["장축 길이(mm)", data.lenLong ?? ""]])
        self.medicineList.append(contentsOf: [["단축 길이(mm)", data.lenShort ?? ""]])
        self.medicineList.append(contentsOf: [["두께", data.thick ?? ""]])
        self.medicineList.append(contentsOf: [["제형 코드 이름", data.formCodeName ?? ""]])
        self.medicineList.append(contentsOf: [["앞면 마크내용", data.markCodeFrontAnal ?? ""]])
        self.medicineList.append(contentsOf: [["뒷면 마크내용", data.markCodeBackAnal ?? ""]])
        self.medicineList.append(contentsOf: [["앞면 마크코드", data.markCodeFront ?? ""]])
        self.medicineList.append(contentsOf: [["뒷면 마크코드", data.markCodeBack ?? ""]])
        self.medicineList.append(contentsOf: [["보험 코드", data.ediCode ?? ""]])
        self.medicineList.append(contentsOf: [["이미지 링크", data.medicineImage ?? ""]])
        self.medicineList.append(contentsOf: [["앞면 마크\n이미지 링크", data.markCodeFrontImage ?? ""]])
        self.medicineList.append(contentsOf: [["뒷면 마크\n이미지 링크", data.markCodeBackImage ?? ""]])
        self.medicineList.append(contentsOf: [["품목 허가 일지", data.medicinePermitDate ?? ""]])
        self.medicineList.append(contentsOf: [["약학 정보원\n이미지 생성일", data.imgRegistTs ?? ""]])
        self.medicineList.append(contentsOf: [["변경 일자", data.ediCode ?? ""]])
    }
    
    func setupLayout() {
        [
            backgroundView,
            titleLabel,
            classLabel,
            directionButton,
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
        
        classLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10.0)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing).inset(100.0)
        }
        
        directionButton.snp.makeConstraints {
            $0.top.equalTo(classLabel.snp.top)
            $0.trailing.equalTo(titleLabel.snp.trailing)
            $0.width.equalTo(100.0)
        }
        
        pillImageView.snp.makeConstraints {
            $0.top.equalTo(classLabel.snp.bottom).offset(20.0)
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
