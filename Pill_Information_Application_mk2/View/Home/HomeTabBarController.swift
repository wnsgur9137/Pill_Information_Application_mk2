//
//  HomeTabBarController.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/22.
//

import UIKit
import SnapKit

final class HomeTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 2
        self.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let boardTab = UINavigationController(rootViewController: BoardView())
        let boardTabItem = UITabBarItem(title: "게시판", image: UIImage(named: "board"), selectedImage: UIImage(named: "board.fill"))
        boardTab.tabBarItem = boardTabItem
        
        let searchTab = UINavigationController(rootViewController: SearchView())
        let searchTabItem = UITabBarItem(title: "약 검색", image: UIImage(named: "pills"), selectedImage: UIImage(named: "pills.fill"))
        searchTab.tabBarItem = searchTabItem
        
//        let homeTab = UINavigationController(rootViewController: HomeView())
        let homeTab = HomeView()
        let homeTabItem = UITabBarItem(title: "홈", image: UIImage(named: "house"), selectedImage: UIImage(named: "house.fill"))
        homeTab.tabBarItem = homeTabItem
        
        let alarmTab = UINavigationController(rootViewController: AlarmView())
        let alarmTabItem = UITabBarItem(title: "알람", image: UIImage(named: "alarm"), selectedImage: UIImage(named: "alarm.fill"))
        alarmTab.tabBarItem = alarmTabItem
        
        let profileTab = UINavigationController(rootViewController: ProfileView())
        let profileTabItem = UITabBarItem(title: "내정보", image: UIImage(named: "persion.crop.circle"), selectedImage: UIImage(named: "person.crop.circle.fill"))
        profileTab.tabBarItem = profileTabItem
        
        self.viewControllers = [boardTab, searchTab, homeTab, alarmTab, profileTab]
    }
}

extension HomeTabBarController: UITabBarControllerDelegate {
    
}
