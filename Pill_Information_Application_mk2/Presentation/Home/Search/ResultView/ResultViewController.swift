//
//  ResultViewController.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/31.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

import Alamofire

final class ResultViewController: UIViewController {
    let disposeBag = DisposeBag()
    
//    let searchBar = SearchBar()
    
//    let tableView = ResultTableView()
    
//    var searchMedicineData: Dictionary<String, String>?
    var searchMedicineData: Array<String>?
    var medicineArray: [MedicineFastAPIItem] = []
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var medicineCountLabel: UILabel = {
        let label = UILabel()
        label.text = "총 0개".localized()
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        return label
    }()
    
    private lazy var resultTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ResultTableViewCell.self, forCellReuseIdentifier: "ResultTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "알약 검색 결과".localized()
        print(medicineArray.count)
        LoadingView.show()
        bind()
        attribute()
        setupLayout()
        LoadingView.hide()
    }
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("medicineArray: \(medicineArray)")
        return medicineArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if medicineArray.count == 0 {
            return UITableViewCell()
        }
        guard let cell = resultTableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath) as? ResultTableViewCell else { return UITableViewCell() }
        cell.setDataFastAPI(data: medicineArray[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.searchType = "shape"
//        vc.medicineImage = medicineArray[]
        vc.medicineFastAPI = medicineArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


private extension ResultViewController {
    func bind() {
        
    }
    
    func attribute() {
        var param = "?medicineShape=\(searchMedicineData![0].addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed)!)"
        param += "&medicineColor=\(searchMedicineData![1].addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed)!)"
        param += "&medicineLine=\(searchMedicineData![2].addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed)!)"
        param += "&medicineCode=\(searchMedicineData![3].addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed)!)"
        let url = "\(ubuntuServer.host + ubuntuServer.path)/getMedicineListShape/\(param)"

        print("\n\n")
        print(url)
        AF.request(url, method: .post)
            .response(completionHandler: { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case let .success(data):
                    do {
                        let result = try JSONDecoder().decode(MedicineFastAPIOverview.self, from: data!)
//                        print("result: \(result)")
//                        self.medicineCountLabel.text = "총 \(result.resultCount)개"
                        self.medicineCountLabel.text = "총 %d개".localized(with: result.resultCount)
                        for index in 0..<result.medicineItem.count {
                            self.medicineArray.append(result.medicineItem[index])
                        }
                        DispatchQueue.main.async {
                            self.resultTableView.reloadData()
                        }
                    } catch {
                        let alertCon = UIAlertController(
                            title: "해당하는 알약이 존재하지 않습니다".localized(),
                            message: nil,
                            preferredStyle: UIAlertController.Style.alert)
                        let alertAct = UIAlertAction(
                            title: "확인".localized(),
                            style: UIAlertAction.Style.default,
                            handler: { _ in self.emptyMedicine()
                            }
                        )
                        alertCon.addAction(alertAct)
                        self.present(alertCon, animated: true, completion: nil)
                    }
                case let .failure(error):
                    print("failure: \(error)")
                    let alertCon = UIAlertController(
                        title: "해당하는 알약이 없습니다.".localized(),
                        message: nil,
                        preferredStyle: UIAlertController.Style.alert)
                    let alertAct = UIAlertAction(
                        title: "확인".localized(),
                        style: UIAlertAction.Style.default,
                        handler: { _ in self.dismiss(animated: true)}
                    )
                    alertCon.addAction(alertAct)
                    self.present(alertCon, animated: true, completion: nil)
                }
            })
    }
    
    func emptyMedicine() {
        print("emptyMedicine")
        self.dismiss(animated: true)
    }
    
    func setupLayout() {
        [
            backgroundView,
//            searchBar,
            medicineCountLabel,
            resultTableView
        ].forEach{ view.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
//        searchBar.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide)
//            $0.leading.trailing.equalToSuperview()
//        }
        
        medicineCountLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10.0)
            $0.trailing.equalToSuperview().offset(-20.0)
        }
        
        resultTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(25.0)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
