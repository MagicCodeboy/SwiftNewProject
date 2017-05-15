//
//  SHTabbarController.swift
//  SwiftNewProject
//
//  Created by lalala on 2017/5/9.
//  Copyright © 2017年 lsh. All rights reserved.
//

import UIKit

class SHTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置tabbar图标的颜色
        tabBar.tintColor = NAVIGATIONBAR_RED_COLOR
        
        //添加所有的自控制器
        addAllChildViewController()
    }
    fileprivate func addAllChildViewController() {
        //新闻页面
        let newsVC = UIStoryboard.init(name: "SHNewsViewController", bundle: Bundle.main).instantiateViewController(withIdentifier: "SHNewsViewController")
        addChildViewCOntroller(newsVC, title: "咨询", imageName: "tabbar_icon_news")
        
        //图秀
        let photoVC = UIStoryboard.init(name: "SHPhotoViewController", bundle: nil).instantiateViewController(withIdentifier: "SHPhotoViewController")
        addChildViewCOntroller(photoVC, title: "图秀", imageName: "tabbar_icon_media")
        
        //热门
        let hotsVC = UIStoryboard.init(name: "SHHotsViewController", bundle: nil).instantiateViewController(withIdentifier: "SHHotsViewController")
        addChildViewCOntroller(hotsVC, title: "热门", imageName: "tabbar_icon_reader")
        
        //我的
        let profileVC = UIStoryboard.init(name: "SHProfileViewController", bundle: nil).instantiateViewController(withIdentifier: "SHProfileViewController")
        addChildViewCOntroller(profileVC, title: "我的", imageName: "tabbar_icon_me")
        
    }
    fileprivate func addChildViewCOntroller(_ childController: UIViewController, title: String, imageName: String) {
        childController.title = title
        childController.tabBarItem.title = title
        childController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
        childController.tabBarItem.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 12)], for: .normal)
        childController.tabBarItem.image = UIImage(named: "\(imageName)_normal")?.withRenderingMode(.alwaysOriginal)
        childController.tabBarItem.selectedImage = UIImage(named: "\(imageName)_highlight")?.withRenderingMode(.alwaysOriginal)
        let nav = SHNavigationController(rootViewController: childController)
        addChildViewController(nav)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
