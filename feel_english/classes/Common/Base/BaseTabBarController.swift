//
//  BaseTabBarController.swift
//  feel
//
//  Created by erheng on 2019/5/27.
//  Copyright © 2019 mengxsh. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addChildViewControllers()
    }
    
    // 添加子控制器
    func addChildViewControllers()
    {
        setChiledViewController(HomeViewController(), title: "首页", imageName: "btn_home_normal",
                                selectedImageName: "btn_home_selected")
        
        setChiledViewController(LearnPleanViewController(), title: "学习", imageName: "btn_user_normal",
                                selectedImageName: "btn_user_selected")
        
        setChiledViewController(MeViewController(), title: "我的", imageName: "btn_user_normal",
                                selectedImageName: "btn_user_selected")
    }
    
    // 初始化子控制器
    func setChiledViewController(_ childController: UIViewController, title: String,
                           imageName: String, selectedImageName: String)
    {
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: selectedImageName)
        childController.title = title
        
        let navigationController = BaseNavigationController(rootViewController: childController)
        addChild(navigationController)
    }
}
