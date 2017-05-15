//
//  SHNavigationController.swift
//  SwiftNewProject
//
//  Created by lalala on 2017/5/8.
//  Copyright © 2017年 lsh. All rights reserved.
//

import UIKit

class SHNavigationController: UINavigationController,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = navigationBar
        navBar.backgroundColor = NAVIGATIONBAR_WHITE_COLOR
        navBar.isTranslucent = false
        navBar.barStyle = UIBarStyle.default
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.shadowImage = UIImage()
        navBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.init(red: 0.173, green: 0.173, blue: 0.173, alpha: 1),
            NSFontAttributeName: UIFont.systemFont(ofSize: 18)
        ]
        //全屏返回手势
        panGestureBack()
    }
    //全屏返回手势
    func panGestureBack() {
        let target = interactivePopGestureRecognizer?.delegate
        let pan = UIPanGestureRecognizer.init(target: target, action: Selector("handleNavigationTransition:"))
        pan.delegate = self
        view.addGestureRecognizer(pan)
        interactivePopGestureRecognizer?.isEnabled = false
    }
    //UIGestureRecognizeDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if childViewControllers.count == 1 {
            return false
        } else {
            return true
        }
    }
    //拦截push操作
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        } else {
            viewController.hidesBottomBarWhenPushed = false
        }
        super.pushViewController(viewController, animated: animated)
        
        //压入栈后创建返回按钮
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.init(named: "")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal),
            style: UIBarButtonItemStyle.done,
            target: self,
            action: #selector(back)
        )
    }
    
    //全局返回操作
    @objc fileprivate func back() {
        popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
