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
import SwiftyJSON
import SafariServices

final class HomeViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let searchBar = SearchBar()
    var tableNoticeList: [NoticeOverview] = []
    
//    private lazy var noticeTableView = NoticeTableView()
    
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
    
    private lazy var safetyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "앱 사용 경고 사항 제목".localized()
//        label.backgroundColor = .lightGray
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 16.0, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var safetyLabel: UILabel = {
        let label = UILabel()
        label.text = "앱 사용 경고 사항".localized()
        label.textColor = .label
        label.font = .systemFont(ofSize: 12.0, weight: .regular)
        label.numberOfLines = 0

//        label.layer.borderColor = UIColor.black.cgColor
//        label.layer.borderWidth = 1.0
//        label.layer.cornerRadius = 3.0
        return label
    }()
    
    private lazy var koreaPharmaceuticalInfoCenterLabel: UILabel = {
        
        let label = UILabel()
        label.text = "koreaPharmaceuticalInfoCenter".localized()
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 12.0, weight: .bold)
        
        label.isUserInteractionEnabled = true
        
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(fixedLabelTapped(_:))
        )
        label.addGestureRecognizer(recognizer)
        
        return label
    }()
    
    private lazy var noticeLabel: UILabel = {
        let label = UILabel()
        label.text = "공지사항".localized()
        label.font = .systemFont(ofSize: 17.0, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var noticeTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NoticeTableViewCell.self, forCellReuseIdentifier: "NoticeTableViewCell")
        return tableView
    }()
    
    private lazy var addNoticeButton: UIButton = {
        let button = UIButton()
        button.setImage(systemName: "plus.app")
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(addNoticeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableNoticeList = []
        self.getNotice(completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(result):
                if result.noticeList.count > 0 {
                    for ind in 0...(result.noticeList.count - 1) {
                        self.tableNoticeList.append(result.noticeList[ind])
                    }
                    print("\n\nSUCCESS:")
                    debugPrint("success \(result)")
                    DispatchQueue.main.async {
                        self.noticeTableView.reloadData()
                    }
                }
            case let .failure(error):
                debugPrint("FAILURE: \(error)")
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "PillSoGood"
        bind()
        setupLayout()
        if UserDefaults.standard.string(forKey: "email") == "wnsgur9137@icloud.com" ||
            UserDefaults.standard.string(forKey: "email") == "admin@admin.com" {
            setupAddNoticeButton()
        }
//        keyboardAtrribute()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func keyboardAtrribute() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableNoticeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableNoticeList.count == 0 {
            return UITableViewCell()
        }
        guard let cell = noticeTableView.dequeueReusableCell(withIdentifier: "NoticeTableViewCell", for: indexPath) as? NoticeTableViewCell else { return UITableViewCell() }
        cell.setData("\(String(describing: tableNoticeList[indexPath.row].title ?? ""))")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = NoticeDetailViewController()
        vc.setData(
            id: tableNoticeList[indexPath.row].id!,
            title: tableNoticeList[indexPath.row].title!,
            writer: tableNoticeList[indexPath.row].writer!,
            content: tableNoticeList[indexPath.row].content!)
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
    
    func getNotice(completionHandler: @escaping (Result<NoticeListOverview, Error>) -> Void) {
//        let url = "\(FastAPI.host + FastAPI.path)/getAllNotices"
        let url = "\(ubuntuServer.host + ubuntuServer.path)/getAllNotices"
        
        // 우분투 서버로 수정
        AF.request(url, method: .get)
            .response(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    print("success: \(String(describing: data))")
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(NoticeListOverview.self, from: data!)
                        print("result: \(result)")
                        completionHandler(.success(result))
                    } catch {
                        print("failure: \(error)")
                        completionHandler(.failure(error))
                    }

                case let .failure(error):
                    print("failure: \(error)")
                    completionHandler(.failure(error))
                }
            })
    }
    
    @objc func fixedLabelTapped(_ sender: UITapGestureRecognizer) {
        //fixedLabel에서 UITapGestureRecognizer로 선택된 부분의 CGPoint를 구합니다.
        let point = sender.location(in: koreaPharmaceuticalInfoCenterLabel)
        
        // fixedLabel 내에서 문자열 google이 차지하는 CGRect값을 구해, 그 안에 point가 포함되는지를 판단합니다.
        
        if let koreaRect = koreaPharmaceuticalInfoCenterLabel.boundingRectForCharacterRange(subText: "koreaPharmaceuticalInfoCenter".localized()), koreaRect.contains(point) {
            let alertCon = UIAlertController(
                title: "앱 외부 사이트로 전환".localized(),
                message: nil,
                preferredStyle: UIAlertController.Style.alert
            )
            let alertActYes = UIAlertAction(
                title: "이동".localized(),
                style: UIAlertAction.Style.default,
                handler: { [weak self] _ in
                    self?.present(url: "https://www.health.kr/")
                }
            )
            let alertActNo = UIAlertAction(
                title: "취소".localized(),
                style: UIAlertAction.Style.cancel
            )
            [ alertActYes, alertActNo ].forEach{alertCon.addAction($0)}
            self.present(alertCon, animated: true, completion: nil)
        }

//        if let googleRect = koreaPharmaceuticalInfoCenterLabel.boundingRectForCharacterRange(subText: "google"),googleRect.contains(point) {
//            present(url: "https://www.google.com")
//        }
//        if let githubRect = koreaPharmaceuticalInfoCenterLabel.boundingRectForCharacterRange(subText: "github"),githubRect.contains(point) {
//            present(url: "https://www.github.com")
//        }
    }

    func present(url string: String) {
      if let url = URL(string: string) {
        let viewController = SFSafariViewController(url: url)
        present(viewController, animated: true)
      }
    }
    
    func setupLayout() {
        [
            backgroundView,
//            searchBar,
            imageView,
            safetyTitleLabel,
            safetyLabel,
            koreaPharmaceuticalInfoCenterLabel,
            noticeLabel,
            noticeTableView
        ].forEach{ view.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
//        searchBar.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide)
//            $0.leading.trailing.equalToSuperview()
//        }
        
        imageView.snp.makeConstraints {
//            $0.top.equalTo(searchBar.snp.bottom).offset(40)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(80.0)
            $0.width.equalTo(340.0)
        }
        
        safetyTitleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(30.0)
            $0.centerX.equalToSuperview()
        }
        
        safetyLabel.snp.makeConstraints {
            $0.top.equalTo(safetyTitleLabel.snp.bottom).offset(10.0)
            $0.leading.equalToSuperview().offset(25.0)
            $0.trailing.equalToSuperview().offset(-25.0)
        }
        
        koreaPharmaceuticalInfoCenterLabel.snp.makeConstraints {
            $0.top.equalTo(safetyLabel.snp.bottom).offset(5.0)
            $0.leading.equalToSuperview().offset(25.0)
            $0.trailing.equalToSuperview().offset(-25.0)
        }
        
        noticeLabel.snp.makeConstraints {
            $0.top.equalTo(koreaPharmaceuticalInfoCenterLabel.snp.bottom).offset(30.0)
            $0.leading.equalToSuperview().offset(20.0)
        }
        
        noticeTableView.snp.makeConstraints {
            $0.top.equalTo(noticeLabel.snp.bottom).offset(5.0)
            $0.leading.equalTo(noticeLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(10.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20.0)
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
