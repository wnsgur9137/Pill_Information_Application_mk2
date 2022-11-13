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

final class DetailViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let medicineData = PublishSubject<[ResultTableViewCellData]>()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
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
        button.addTarget(self, action: #selector(directionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var pillImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray
        // KingFisher
//        imageView.image =
        return imageView
    }()
    
    private lazy var contentTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "알약 정보"
        bind()
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

private extension DetailViewController {
    func bind() {
        
    }
    
    @objc func directionButtonTapped() {
        let vc = DirectionViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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
            $0.top.equalTo(classLabel.snp.bottom).offset(50.0)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing)
            $0.height.equalTo(150.0)
        }
        
        contentTableView.snp.makeConstraints {
            $0.top.equalTo(pillImageView.snp.bottom).offset(50.0)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
