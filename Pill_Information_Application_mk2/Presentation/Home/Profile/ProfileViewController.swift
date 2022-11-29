//
//  ProfileViewController.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

import Firebase
import FirebaseAuth
import Alamofire

final class ProfileViewController: UIViewController {
    
    var loginCheckBool: Bool = false
    let disposeBag = DisposeBag()
    var starList: Array = [[String]]()
    var starMedicineData: MedicineItem?
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var userImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person")
        image.tintColor = .label
        image.backgroundColor = .lightGray
        return image
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름".localized()
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var userUpdateButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원 정보 변경".localized(), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
//        button.addTarget(self, action: #selector(userUpdateButtonTapped), for: .touchUpInside)
        return button
    }()
    
//    private lazy var loginButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("로그인", for: .normal)
//        button.setTitleColor(.systemBlue, for: .normal)
//        return button
//    }()
    
    private lazy var loginoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃".localized(), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
//        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var bookmarkLabel: UILabel = {
        let label = UILabel()
        label.text = "즐겨찾기".localized()
        label.font = .systemFont(ofSize: 17.0, weight: .regular)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private lazy var resetBookmarkButton: UIButton = {
        let button = UIButton()
        button.setTitle("즐겨찾기 초기화".localized(), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .regular)
//        button.addTarget(self, action: #selector(resetBookmarkButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var userStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            userImageView,
            userInfoStackView,
            loginoutButton
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 20.0
        stackView.layer.borderColor = UIColor.gray.cgColor
        stackView.layer.borderWidth = 1.0
        stackView.layer.cornerRadius = 8.0
        return stackView
    }()
    
    private lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            userNameLabel,
            userUpdateButton
        ])
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var bookmarkStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            bookmarkLabel,
            resetBookmarkButton
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var bookmarkTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "내 정보".localized()
        
        // 로그인 체크
        self.loginCheckBool = self.loginCheck()
        
        // 즐겨찾기
        self.bookmarkTableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: "BookmarkTableViewCell")
        self.bookmarkTableView.delegate = self
        self.bookmarkTableView.dataSource = self
        
        bind()
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        attribute()
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if starList == [[]] {
            return 0
        }
        return starList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkTableViewCell", for: indexPath) as? BookmarkTableViewCell else { return UITableViewCell() }
        if starList != [[] ] {
            cell.setData(starList[indexPath.row][0], starList[indexPath.row][1], starList[indexPath.row][2], starList[indexPath.row][3])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        getStarMedicineData(medicineName: starList[indexPath.row][0], completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(result):
                print("----success----")
                self.starMedicineData = result.body.items[0]
                let vc = DetailViewController()
                vc.medicine = self.starMedicineData
                self.navigationController?.pushViewController(vc, animated: true)
            case let .failure(error):
                print("----failure----\n\(error)")
                let alertCon = UIAlertController(title: nil, message: "해당 정보를 찾을 수 없습니다.\n잠시후 다시 시도해주십시오.".localized(), preferredStyle: UIAlertController.Style.alert)
                let alertAct = UIAlertAction(title: "확인".localized(), style: UIAlertAction.Style.default)
                alertCon.addAction(alertAct)
                self.present(alertCon, animated: true)
            }
        })
    }
}

private extension ProfileViewController {
    
    func bind() {
        resetBookmarkButton.rx.tap
            .bind(onNext: { [weak self] in
                if self?.starList == [[]] {
                    let alertCon = UIAlertController(
                        title: "즐겨찾기가 없습니다.".localized(),
                        message: "알약을 검색하고 즐겨찾기를 추가해 보세요.".localized(),
                        preferredStyle: UIAlertController.Style.alert)
                    let alertAct = UIAlertAction(
                        title: "확인".localized(),
                        style: UIAlertAction.Style.default)
                    alertCon.addAction(alertAct)
                    self?.present(alertCon, animated: true, completion: nil)
                } else {
                    let alertCon = UIAlertController(title: "즐겨찾기를 초기화하시겠습니까?".localized(), message: nil, preferredStyle: UIAlertController.Style.alert)
                    let alertActYes = UIAlertAction(title: "예".localized(), style: UIAlertAction.Style.destructive, handler: { _ in
                        UserDefaults.standard.removeObject(forKey: "starList")
                        self?.starList = [[]]
                        DispatchQueue.main.async {
                            self?.bookmarkTableView.reloadData()
                        }
                    })
                    let alertActNo = UIAlertAction(title: "아니오".localized(), style: UIAlertAction.Style.default)
                    alertCon.addAction(alertActYes)
                    alertCon.addAction(alertActNo)
                    self?.present(alertCon, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        loginoutButton.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                print(self.loginCheckBool)
                if self.loginCheckBool {
                    let alertCon = UIAlertController(title: "로그아웃".localized(), message: "로그아웃 하시겠습니까?".localized(), preferredStyle: UIAlertController.Style.alert)
                    let alertActCancel = UIAlertAction(title: "아니오".localized(), style: UIAlertAction.Style.default)
                    let alertActSure = UIAlertAction(title: "예".localized(), style: UIAlertAction.Style.destructive, handler: { _ in
                        self.logout()
                    })
                    alertCon.addAction(alertActCancel)
                    alertCon.addAction(alertActSure)
                    self.present(alertCon, animated: true)
                } else {
//                    let vc = MainViewController()
//                    let vc = EmailLoginViewController()
                    let vc = UINavigationController(rootViewController: EmailLoginViewController())
//                    vc.modalPresentationStyle = .pageSheet
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        userUpdateButton.rx.tap
            .bind(onNext: { [weak self] in
                let vc = ProfileUpdateViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
//    @objc func logoutButtonTapped() {
//        let alertCon = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
//        let alertActCancel = UIAlertAction(title: "아니오", style: UIAlertAction.Style.default)
//        let alertActSure = UIAlertAction(title: "예", style: UIAlertAction.Style.destructive, handler: { [weak self] _ in
//            self?.logout()
//        })
//        alertCon.addAction(alertActCancel)
//        alertCon.addAction(alertActSure)
//        present(alertCon, animated: true)
//    }
    
//    @objc func userUpdateButtonTapped() {
//        let vc = ProfileUpdateViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
//    @objc func resetBookmarkButtonTapped() {
//        let alertCon = UIAlertController(title: "경고", message: "즐겨찾기를 초기화하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
//        let alertActYes = UIAlertAction(title: "예", style: UIAlertAction.Style.destructive, handler: { _ in
//            UserDefaults.standard.removeObject(forKey: "starList")
//        })
//        let alertActNo = UIAlertAction(title: "아니오", style: UIAlertAction.Style.default)
//        alertCon.addAction(alertActYes)
//        alertCon.addAction(alertActNo)
//        self.present(alertCon, animated: true)
//    }
    
    func loginCheck() -> Bool {
        let userEmail = UserDefaults.standard.string(forKey: "email")
        if userEmail == "" {
            return false
        } else {
            return true
        }
    }
    
    func getStarMedicineData(medicineName: String, completionHandler: @escaping (Result<MedicineOverview, Error>) -> Void) {
        
        let url = "\(MedicineAPI.scheme)://\(MedicineAPI.host + MedicineAPI.path)?serviceKey=\(MedicineAPI.apiKeyEncoding)&item_name=\(String(describing: medicineName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!))&type=json"
        
//        let param = [
//            "serviceKey": MedicineAPI.apiKeyEncoding,
//            "item_name": medicineName,
//            "type": "json"
//        ]
        
        print(url)
        
        AF.request(url, method: .get)
            .response(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    print("success: \(String(describing: data))")
                    do {
                        let medicineData = try JSONDecoder().decode(MedicineOverview.self, from: data!)
                        print(medicineData)
                        completionHandler(.success(medicineData))
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
    
    func logout() {
        do {
            // 자동 로그인 제거
            UserDefaults.standard.removeObject(forKey: "loginType")
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "passwd")
            UserDefaults.standard.removeObject(forKey: "nickname")
            
            // 로그아웃
            try Auth.auth().signOut()
            self.loginCheckBool = false
            self.attribute()
            
            // 초기 필수 로그인일 경우
//            let vc = MainViewController()
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print("ERROR: signout \(signOutError.localizedDescription)")
        }
    }
    
    func attribute() {
        
        if loginCheckBool {
            [
                userUpdateButton
            ].forEach {
                $0.isHidden = false
            }
            loginoutButton.setTitle("로그아웃".localized(), for: .normal)
//            userNameLabel.text = "\(String(describing: UserDefaults.standard.string(forKey: "nickname")!)) 님"
            userNameLabel.text = "%s 님".localized(with: String(describing: UserDefaults.standard.string(forKey: "nickname")!))
            userNameLabel.font = .systemFont(ofSize: 20.0, weight: .bold)
        } else {
            [
                userUpdateButton
            ].forEach {
                $0.isHidden = true
            }
            loginoutButton.setTitle("로그인".localized(), for: .normal)
            userNameLabel.text = "로그인이 \n되어있지 않습니다.".localized()
            userNameLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        }
        
        self.starList = (UserDefaults.standard.array(forKey: "starList") as? [[String]]) ?? [[]]
        self.bookmarkTableView.reloadData()
//        DispatchQueue.main.async {
//            self.bookmarkTableView.reloadData()
//        }
    }
    
    func setupLayout() {
        [
            backgroundView,
            userStackView,
            bookmarkStackView,
            bookmarkTableView
        ].forEach{ view.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        userImageView.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(80)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.width.equalTo(120)
        }
        
        userStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(80)
            $0.width.equalTo(340)
        }
        
        bookmarkStackView.snp.makeConstraints {
            $0.top.equalTo(userStackView.snp.bottom).offset(50)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
//            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        resetBookmarkButton.snp.makeConstraints {
            $0.width.equalTo(150)
        }
        
        bookmarkTableView.snp.makeConstraints {
            $0.top.equalTo(bookmarkStackView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
