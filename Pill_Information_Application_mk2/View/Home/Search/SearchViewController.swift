//
//  SearchViewController.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let searchBar = SearchBar()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var searchLogLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색 기록"
        label.textColor = .label
        label.font = .systemFont(ofSize: 17.0, weight: .bold)
        return label
    }()
    
    private lazy var searchLogDeleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("검색 기록 삭제", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(searchLogDeleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchImageButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var searchLogCollectionView: UICollectionView = {
        let collectionView = UICollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.image = UIImage(named: "Logo_Kor")
        return imageView
    }()
    
    private lazy var searchLogStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            searchLogLabel,
            searchLogDeleteButton
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "알약 검색"
        bind()
        setupLayout()
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tmpLabel : UILabel = UILabel()
        tmpLabel.text = "Test"
        return CGSize(width: (tmpLabel.intrinsicContentSize.width + 10), height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

private extension SearchViewController {
    func bind() {
        
    }
    
    @objc func searchLogDeleteButtonTapped() {
        
    }
    
    func setupLayout() {
        [
            backgroundView,
            searchBar,
            searchLogStackView,
//            searchLogCollectionView,
            searchImageButton,
            imageView
        ].forEach{ view.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        searchLogStackView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            
            searchLogDeleteButton.snp.makeConstraints {
//                $0.leading.equalToSuperview()
                $0.width.equalTo(130)
            }
        }
        
//        searchLogCollectionView.snp.makeConstraints {
//            $0.top.equalTo(searchLogStackView.snp.bottom).offset(10)
//            $0.leading.equalTo(searchLogStackView.snp.leading)
//            $0.trailing.equalTo(searchLogStackView.snp.trailing)
//        }
        
        searchImageButton.snp.makeConstraints {
            $0.top.equalTo(searchLogStackView.snp.bottom).offset(80)
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(100)
        }
        
        
    }
}
