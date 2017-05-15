//
//  SHProgressHUD.swift
//  SwiftNewProject
//
//  Created by lalala on 2017/5/8.
//  Copyright © 2017年 lsh. All rights reserved.
//

import UIKit
import SVProgressHUD

class SHProgressHUD: NSObject {
    
    class func setUpHUD() {
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setBackgroundColor(UIColor(white: 0.0, alpha: 0.8))
        SVProgressHUD.setFont(UIFont.boldSystemFont(ofSize: 16))
        SVProgressHUD.setMinimumDismissTimeInterval(2.0)
    }
    class func show() {
         SVProgressHUD.show()
    }
    class func showWithStatus(_ status: String) {
        SVProgressHUD.show(withStatus: status)
    }
    class func showInfoWithStatus(_ status: String) {
        SVProgressHUD.showInfo(withStatus: status)
    }
    class func showSuccessWithStatus(_ status: String) {
        SVProgressHUD.showSuccess(withStatus: status)
    }
    class func showErrorWithStatus(_ status: String) {
        SVProgressHUD.showError(withStatus: status)
    }
    class func dissmiss() {
        DispatchQueue.main.async { () -> Void in
            SVProgressHUD.dismiss()
        }
    }
}
