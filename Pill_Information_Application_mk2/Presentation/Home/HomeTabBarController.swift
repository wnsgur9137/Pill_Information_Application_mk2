//
//  HomeTabBarController.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/22.
//

import UIKit
import SnapKit
import FirebaseAuth
final class HomeTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.barTintColor = .label
        self.tabBar.tintColor = .label
//        self.tabBar.backgroundColor = .systemBackground
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)
        
//        UserDefaults.standard.removeObject(forKey: "starList")
        
//        do {
//            // 자동 로그인 제거
//            UserDefaults.standard.removeObject(forKey: "loginType")
//            UserDefaults.standard.removeObject(forKey: "email")
//            UserDefaults.standard.removeObject(forKey: "passwd")
//            UserDefaults.standard.removeObject(forKey: "nickname")
//
//            // 로그아웃
//            try Auth.auth().signOut()
//            let vc = MainViewController()
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true, completion: nil)
//        } catch let signOutError as NSError {
//            print("ERROR: signout \(signOutError.localizedDescription)")
//        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let boardTab = UINavigationController(rootViewController: BoardViewController())
//        let boardTabItem = UITabBarItem(
//            title: "게시판",
//            image: UIImage(systemName: "board"),
//            selectedImage: UIImage(systemName: "board.fill")
//        )
//        boardTab.tabBarItem = boardTabItem
        
        let searchTab = UINavigationController(rootViewController: SearchViewController())
        let searchTabItem = UITabBarItem(
            title: "약 검색",
            image: UIImage(systemName: "pills"),
            selectedImage: UIImage(systemName: "pills.fill")
        )
        searchTabItem.badgeColor = .white
        searchTab.tabBarItem = searchTabItem
        
//        let homeTab = UINavigationController(rootViewController: HomeView())
        let homeTab = UINavigationController(rootViewController: HomeViewController())
        let homeTabItem = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        homeTab.tabBarItem = homeTabItem
        
        let alarmTab = UINavigationController(rootViewController: AlarmViewController())
        let alarmTabItem = UITabBarItem(
            title: "알람/타이머",
            image: UIImage(systemName: "alarm"),
            selectedImage: UIImage(systemName: "alarm.fill")
        )
        alarmTab.tabBarItem = alarmTabItem
        
        let profileTab = UINavigationController(rootViewController: ProfileViewController())
        let profileTabItem = UITabBarItem(
            title: "내 정보",
            image: UIImage(systemName: "person.circle"),
            selectedImage: UIImage(systemName: "person.circle.fill")
        )
        profileTab.tabBarItem = profileTabItem
        
        self.viewControllers = [searchTab, homeTab, alarmTab, profileTab]
        
        self.selectedIndex = 1
    }
}

extension HomeTabBarController: UITabBarControllerDelegate {
    
}
