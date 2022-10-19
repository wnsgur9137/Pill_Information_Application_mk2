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

//error build: In /Users/junhyeok/study/Xcode/Pill_Information_Application_mk2/Pods/GoogleSignIn/Frameworks/GoogleSignIn.framework/GoogleSignIn(GIDAuthStateMigration_425a588fcd149b383bb30d0e6a3b4322.o), building for iOS Simulator, but linking in object file built for iOS, file '/Users/junhyeok/study/Xcode/Pill_Information_Application_mk2/Pods/GoogleSignIn/Frameworks/GoogleSignIn.framework/GoogleSignIn' for architecture arm64
