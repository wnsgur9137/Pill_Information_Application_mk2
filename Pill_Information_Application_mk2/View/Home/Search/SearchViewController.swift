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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "알약 검색"
        bind()
        setupLayout()
    }
}

private extension SearchViewController {
    func bind() {
        
    }
    
    func setupLayout() {
        [
            searchBar
        ].forEach{ view.addSubview($0) }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
