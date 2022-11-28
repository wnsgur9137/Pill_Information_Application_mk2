//
//  SearchBar.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/29.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchBar: UISearchBar {
    
    let disposeBag = DisposeBag()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("검색", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private lazy var photoButton: UIButton = {
        let button = UIButton()
        button.setTitle("모양", for: .normal)
        button.setImage(UIImage(named: "photo"), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    // SearchBar Button Tapped Event
    // 탭 이벤트만 전달되기에 Void로 설정
    var searchButtonTapped = PublishRelay<Void>()
    var photoButtonTapped = PublishRelay<Void>()
    
    // SearchBar 외부로 내보낼 Event
    var shouldLoadResult = Observable<String>.of("")
    var photoButtonTappedResult = Observable<String>.of("")
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bind()
        attribute()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        Observable
            .merge(
                self.rx.searchButtonClicked.asObservable(),
                searchButton.rx.tap.asObservable()
            )
            .bind(to: searchButtonTapped)
            .disposed(by: disposeBag)
        
        searchButtonTapped
            .asSignal()
            .emit(to: self.rx.endEditing)
            .disposed(by: disposeBag)
        
        searchButtonTapped
            .subscribe(onNext: { [weak self] in
                if self?.text == "" {
                    return
                }
                var searchHistoryArray = UserDefaults.standard.array(forKey: "searchHistoryArray") as? Array<String>
                if searchHistoryArray == nil {
                    UserDefaults.standard.set([], forKey:"searchHistoryArray")
                    searchHistoryArray = UserDefaults.standard.array(forKey: "searchHistoryArray") as? Array<String>
                }
                if !searchHistoryArray!.contains(String((self?.text)!)) {
                    searchHistoryArray!.append((self?.text)!)
                }
                UserDefaults.standard.set(searchHistoryArray, forKey: "searchHistoryArray")
//                print("searchHistoryArray: \(String(describing: searchHistoryArray!))")
            })
            .disposed(by: disposeBag)
        
        self.shouldLoadResult = searchButtonTapped
            .withLatestFrom(self.rx.text) { $1 ?? ""}
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
        
        photoButton.rx.tap
            .bind(to: photoButtonTapped)
            .disposed(by: disposeBag)
        
        self.photoButtonTappedResult = photoButtonTapped
            .withLatestFrom(self.rx.text) { $1 ?? ""}
        
        
    }
    
}

private extension SearchBar {
    
    func attribute() {
        
    }
    
    func setupLayout() {
//        addSubview(searchButton)
        [
            searchButton,
            photoButton
        ].forEach{ addSubview($0) }
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-12)
            $0.centerY.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
//            $0.trailing.equalToSuperview().inset(36)
            $0.trailing.equalTo(photoButton.snp.leading).offset(-12)
        }
        
        photoButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
    }
}

// serachBar EndEditing
extension Reactive where Base: SearchBar {
    var endEditing: Binder<Void> {
        return Binder(base) { base, _ in
            base.endEditing(true)
        }
    }
}
