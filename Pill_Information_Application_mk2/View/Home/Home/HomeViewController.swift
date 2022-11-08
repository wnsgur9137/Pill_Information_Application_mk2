//
//  HomeViewController.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

import Alamofire

final class HomeViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let searchBar = SearchBar()
    var noticeList: [NoticeOverview] = []
    
    // tableView = NoticeTableView()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo_Eng")
//        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private lazy var noticeLabel: UILabel = {
        let label = UILabel()
        label.text = "공지사항"
        label.font = .systemFont(ofSize: 17.0, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var noticeTableView: UITableView = {
        let tableView = UITableView()
//        tableView.backgroundColor = .systemCyan
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var addNoticeButton: UIButton = {
        let button = UIButton()
        button.setImage(systemName: "plus.app")
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(addNoticeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "PillSoGood"
        bind()
        setupLayout()
        if UserDefaults.standard.string(forKey: "email") == "wnsgur9137@icloud.com" {
            setupAddNoticeButton()
        }
        getNotice()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = NoticeDetailViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

private extension HomeViewController {
    func bind() {
        
    }
    
    @objc func addNoticeButtonTapped() {
        let vc = AddNoticeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getNotice() {
        let url = "\(useAPI.host + useAPI.path)/getNotice"
        
        AF.request(url, method: .get)
            .response(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    print("success: \(data)")
                case let .failure(error):
                    print("failure: \(error)")
                }
            })
    }
    
    func setupLayout() {
        [
            backgroundView,
            searchBar,
            imageView,
            noticeLabel,
            noticeTableView
        ].forEach{ view.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(80)
            $0.width.equalTo(340)
        }
        
        noticeLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(60)
            $0.leading.equalToSuperview().offset(20)
        }
        
        noticeTableView.snp.makeConstraints {
            $0.top.equalTo(noticeLabel.snp.bottom).offset(5)
            $0.leading.equalTo(noticeLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    func setupAddNoticeButton() {
        
        view.addSubview(addNoticeButton)
        
        addNoticeButton.snp.makeConstraints {
            $0.top.equalTo(noticeLabel.snp.top)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }
    }
}
