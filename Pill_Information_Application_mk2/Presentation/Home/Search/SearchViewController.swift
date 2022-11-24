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
    let resultTableView = ResultTableView()
    
    let alertActionTapped = PublishRelay<AlertAction>()
    var medicineArray: MedicineOverview? = nil
    var searchHistoryList: Array<String>?
    
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
        return button
    }()
    
    private lazy var searchImageButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var searchLogCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 10
        
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 15.0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.register(SearchHistoryCell.self, forCellWithReuseIdentifier: "SearchHistoryCell")
        
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
//        stackView.layer.borderWidth = 1.0
//        stackView.layer.borderColor = CGColor(gray: 100, alpha: 80)
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "알약 검색"
        bind()
        setupLayout()
        resultTableView.delegate = self
//        keyboardAtrribute()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        super.viewWillDisappear(animated)
        let searchHistoryArray = UserDefaults.standard.array(forKey: "searchHistoryArray") as? Array<String>
        if searchHistoryArray != nil {
            searchHistoryList = searchHistoryArray
        }
        
        DispatchQueue.main.async {
            self.searchLogCollectionView.reloadData()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func keyboardAtrribute() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
////        tapGesture.cancelsTouchesInView = true
//        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchHistoryList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = searchLogCollectionView.dequeueReusableCell(withReuseIdentifier: "SearchHistoryCell", for: indexPath) as? SearchHistoryCell else { return UICollectionViewCell() }
        cell.searchHistoryLabel.text = "  \(String(describing: searchHistoryList![indexPath.row]))"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tmpLabel : UILabel = UILabel()
        tmpLabel.text = searchHistoryList?[indexPath.row]
        return CGSize(width: (tmpLabel.intrinsicContentSize.width + 10), height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.text = searchHistoryList?[indexPath.row]
        searchBar.searchButtonTapped
            .asSignal()
            .emit(to: searchBar.rx.endEditing)
            .disposed(by: disposeBag)
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.medicine = medicineArray!.body.items[indexPath[1]]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

private extension SearchViewController {
    func bind() {
        
        let medicineResult = searchBar.shouldLoadResult
            .flatMapLatest { query in
                MedicineAPINetwork().getMedicineAPI(query: query)
            }
            .share()
        
        let medicineValue = medicineResult
            .compactMap { data -> MedicineOverview? in
                guard case .success(let value) = data else { return nil }
                return value
            }
        
        // 에러를 String 타입으로 반환
        let medicineError = medicineResult
            .compactMap { data -> String? in
                guard case .failure(let error) = data else { return nil }
                return error.localizedDescription
            }
        
        // 네트워크를 통해 가져온 값을 cellData로 반환
        let cellData = medicineValue
            .map { [weak self] medicine -> [ResultTableViewCellData] in
                self?.medicineArray = medicine
                return medicine.body.items
                    .map { item in
                        return ResultTableViewCellData(
                            medicineSeq: item.medicineSeq,
                            medicineName: item.medicineName,
                            entpSeq: item.entpSeq, entpName: item.entpName,
                            chart: item.chart,
                            medicineImage: item.medicineImage,
                            printFront: item.printFront,
                            printBack: item.printBack,
                            medicineShape: item.medicineShape,
                            colorClass1: item.colorClass1,
                            colorClass2: item.colorClass2,
                            lineFront: item.lineFront,
                            lineBack: item.lineBack,
                            lenLong: item.lenLong,
                            lenShort: item.lenShort,
                            thick: item.thick,
                            imgRegistTs: item.imgRegistTs,
                            classNo: item.classNo,
                            className: item.className,
                            etcOtcName: item.etcOtcName,
                            medicinePermitDate: item.medicinePermitDate,
                            formCodeName: item.formCodeName,
                            markCodeFrontAnal: item.markCodeFrontAnal,
                            markCodeBackAnal: item.markCodeBackAnal,
                            markCodeFrontImage: item.markCodeFrontImage,
                            markCodeBackImage: item.markCodeBackImage,
                            medicineEngName: item.medicineEngName,
                            updateDate: item.updateDate, markCodeFront: item.markCodeFront,
                            markCodeBack: item.markCodeBack,
                            ediCode: item.ediCode
//
//                            medicineName: item.medicineName,
//                            medicineImage: item.medicineImage,
//                            className: item.className,
//                            etcOtcName: item.etcOtcName
                        )
                    }
            }
        
        // 정렬 버튼을 누를 경우 나오는 alert
        let sortedType = alertActionTapped
            .filter {
                switch $0 {
                case .medicineName, .className:
                    return true
                default:
                    return false
                }
            }
            .startWith(.medicineName)
        
        // SearchViewController -> ResultTableView
        Observable
            .combineLatest(
                sortedType,
                cellData
            ) { type, data -> [ResultTableViewCellData] in
                switch type {
//                case .medicineName:
//                    return data.sorted { $0.medicineName ?? "" < $1.medicineName ?? ""}
//                case .className:
//                    return data.sorted { $0.className ?? "" < $1.className ?? ""}
                default:
                    return data
                }
            }
            .bind(to: resultTableView.cellData)
            .disposed(by: disposeBag)
        
        let alertForErrorMessage = medicineError
            .map { message -> Alert in
                return (
                    title: "오류",
                    message: "해당 이름의 알약이 없습니다.",
                    actions: [.confirm],
                    style: .alert
                )
            }
        
        let alertSheetForSorting = resultTableView.headerView.sortButtonTapped
            .map { _ -> Alert in
                return (
                    title: nil,
                    message: nil,
                    actions: [.medicineName, .className, .cancel],
                    style: .actionSheet
                )
            }
        
        Observable
            .merge(
                alertSheetForSorting,
                alertForErrorMessage
            )
            .asSignal(onErrorSignalWith: .empty())
            .flatMapLatest { alert -> Signal<AlertAction> in
                let alertController = UIAlertController(
                    title: alert.title,
                    message: alert.message,
                    preferredStyle: alert.style)
                return self.presentAlertController(alertController, actions: alert.actions)
            }
            .emit(to: alertActionTapped)
            .disposed(by: disposeBag)
        
        searchLogDeleteButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if self.searchHistoryList == [] {
                    let alertCon = UIAlertController(
                        title: "경고",
                        message: "검색 기록이 없습니다.",
                        preferredStyle: UIAlertController.Style.alert)
                    let alertAct = UIAlertAction(
                        title: "확인",
                        style: UIAlertAction.Style.default,
                        handler: { _ in return }
                    )
                    alertCon.addAction(alertAct)
                    self.present(alertCon, animated: true, completion: nil)
                }
                let alertCon = UIAlertController(
                    title: "경고",
                    message: "검색 기록을 삭제하시겠습니까?",
                    preferredStyle: UIAlertController.Style.alert)
                let alertActYes = UIAlertAction(
                    title: "예",
                    style: UIAlertAction.Style.destructive,
                    handler: { _ in
                        UserDefaults.standard.removeObject(forKey: "searchHistoryArray")
                        UserDefaults.standard.set([], forKey: "searchHistoryArray")
                        self.searchHistoryList = []
                        DispatchQueue.main.async {
                            self.searchLogCollectionView.reloadData()
                        }
                    }
                )
                let alertActNo = UIAlertAction(
                    title: "아니오",
                    style: UIAlertAction.Style.default)
                
                [alertActNo, alertActYes].forEach{ alertCon.addAction($0) }
                self.present(alertCon, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        

        searchBar.photoButtonTappedResult
            .bind(onNext: { [weak self] _ in
                let vc = PictureSearchViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                searchBar.rx.searchButtonClicked.asObservable(),
                searchBar.searchButton.rx.tap.asObservable()
            )
            .bind(onNext: { [weak self] in
                self?.searchHistoryList = UserDefaults.standard.array(forKey: "searchHistoryArray") as? Array<String>
                DispatchQueue.main.async {
                    self?.searchLogCollectionView.reloadData()
                }
            })
            .disposed(by: disposeBag)
            
    }
    
    func setupLayout() {
        [
            backgroundView,
            searchBar,
            searchLogStackView,
            searchLogCollectionView,
            searchImageButton,
            resultTableView,
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
            $0.top.equalTo(searchBar.snp.bottom).offset(10.0)
            $0.leading.equalToSuperview().offset(20.0)
            $0.trailing.equalToSuperview().inset(20.0)
            
            searchLogDeleteButton.snp.makeConstraints {
//                $0.leading.equalToSuperview()
                $0.width.equalTo(130.0)
            }
        }
        
        searchLogCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchLogStackView.snp.bottom).offset(3.0)
            $0.leading.equalTo(searchLogStackView.snp.leading)
            $0.trailing.equalTo(searchLogStackView.snp.trailing)
            $0.height.equalTo(60.0)
        }
        
        resultTableView.snp.makeConstraints {
            $0.top.equalTo(searchLogCollectionView.snp.bottom).offset(10.0)
            $0.leading.equalTo(searchLogStackView.snp.leading)
            $0.trailing.equalTo(searchLogStackView.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30.0)
        }
        
        searchImageButton.snp.makeConstraints {
            $0.top.equalTo(searchLogStackView.snp.bottom).offset(80)
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(100)
        }
        
        
    }
}


// Alert
extension SearchViewController {
    typealias Alert = (title: String?, message: String?, actions: [AlertAction], style: UIAlertController.Style)
    
    enum AlertAction: AlertActionConvertible {
        case medicineName, className, cancel
        case confirm
        
        var title: String {
            switch self {
            case .medicineName:
                return "MedicineName"
            case .className:
                return "ClassName"
            case .cancel:
                return "취소"
            case .confirm:
                return "확인"
            }
        }
        
        var style: UIAlertAction.Style {
            switch self {
            case .medicineName, .className:
                return .default
            case .cancel, .confirm:
                return .cancel
            }
        }
    }
    
    func presentAlertController<Action: AlertActionConvertible>(_ alertController: UIAlertController, actions: [Action]) -> Signal<Action> {
        if actions.isEmpty { return .empty() }
        return Observable
            .create {[weak self] observer in
                guard let self = self else { return Disposables.create() }
                for action in actions {
                    alertController.addAction(
                        UIAlertAction(
                            title: action.title,
                            style: action.style,
                            handler: { _ in
                                observer.onNext(action)
                                observer.onCompleted()
                            }
                        )
                    )
                }
                self.present(alertController, animated: true, completion: nil)
                
                return Disposables.create {
                    alertController.dismiss(animated: true, completion: nil)
                }
            }
            .asSignal(onErrorSignalWith: .empty())
    }
}
