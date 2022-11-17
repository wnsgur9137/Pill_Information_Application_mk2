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
    
    let tableView = ResultTableView()
    
    var searchMedicineData: Dictionary<String, String>?
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "알약 검색 결과"
        LoadingView.show()
        bind()
        attribute()
        setupLayout()
        LoadingView.hide()
    }
}

//extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return UITableViewCell()
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80.0
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = DetailViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//}


private extension ResultViewController {
    func bind() {
        
    }
    
    func attribute() {
        var url = "\(MedicineAPI.scheme)://\(MedicineAPI.host + MedicineAPI.path)"
        url += "?serviceKey=\(MedicineAPI.apiKeyEncoding)"
        url += "?DRUG_SHAPE"
        
    }
    
    func setupLayout() {
        [
            backgroundView,
//            searchBar,
            tableView
        ].forEach{ view.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
//        searchBar.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide)
//            $0.leading.trailing.equalToSuperview()
//        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
