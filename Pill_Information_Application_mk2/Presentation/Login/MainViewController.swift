//
//  MainViewController.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/13.
//

import UIKit
import SnapKit
import Firebase
import FirebaseAuth

final class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginCheck()
    }
}

private extension MainViewController {
    func loginCheck() {
        
        if let _ = Auth.auth().currentUser {
            print("자동로그인 성공")
            let vc = HomeTabBarController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            
        } else {
            print("자동로그인 실패")
            let rootController = UINavigationController(rootViewController: LoginViewController())
            rootController.modalPresentationStyle = .fullScreen
            self.present(rootController, animated: true, completion: nil)
        }
    }
}
