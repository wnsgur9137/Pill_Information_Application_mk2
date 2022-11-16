//
//  LoadingView.swift
//  Pill_Information
//
//  Created by 이준혁 on 2022/08/04.
//

import Foundation
import UIKit

class LoadingView {
    private static let sharedInstance = LoadingView()
    
    private var backgorundView: UIView?
    private var activityIndicator: UIActivityIndicatorView?
//    private var lblLoading: UILabel?
    
    class func show() {
        let backgroundView = UIView(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        
//        let lblLoading = UILabel(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
//        lblLoading.text = "로딩중..."
//        lblLoading.font = UIFont.boldSystemFont(ofSize: 20)
//        lblLoading.textColor = .black
        
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(backgroundView)
            window.addSubview(activityIndicator)
//            window.addSubview(lblLoading)
            
            backgroundView.frame = CGRect(x: 0, y: 0, width: window.frame.maxX, height: window.frame.maxY)
            backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            
            activityIndicator.center = window.center
            activityIndicator.startAnimating()
            
//            lblLoading.layer.position = CGPoint(x: window.frame.midX, y: window.frame.midY + 30)
            
            sharedInstance.backgorundView?.removeFromSuperview()
            sharedInstance.activityIndicator?.removeFromSuperview()
//            sharedInstance.lblLoading?.removeFromSuperview()
            sharedInstance.backgorundView = backgroundView
            sharedInstance.activityIndicator = activityIndicator
//            sharedInstance.lblLoading = lblLoading
        }
    }
    
    class func hide() {
        if let activityIndicator = sharedInstance.activityIndicator,
//           let lblLoading = sharedInstance.lblLoading,
           let backgroundView = sharedInstance.backgorundView {
            activityIndicator.stopAnimating()
            backgroundView.removeFromSuperview()
            activityIndicator.removeFromSuperview()
//            lblLoading.removeFromSuperview()
        }
    }
}
