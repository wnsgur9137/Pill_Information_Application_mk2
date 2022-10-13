//
//  MainViewController.swift
//  Pill_Information_Application_mk2
//
//  Created by 이준혁 on 2022/10/13.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("123")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginCheck()
    }
}

private extension MainViewController {
    func loginCheck() {
        let rootController = UINavigationController(rootViewController: LoginViewController())
        rootController.modalPresentationStyle = .fullScreen
        self.present(rootController, animated: true, completion: nil)
    }
}
