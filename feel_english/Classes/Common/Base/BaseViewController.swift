//
//  BaseViewController.swift
//  feel_english
//
//  Created by erheng on 2019/11/23.
//  Copyright © 2019 deepfeel. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }


    func setLeftBarButton(imageName: String)
    {
        let leftButton = UIButton(type: .custom);

        let statusBarHeight = STATUS_BAR_HEIGHT
        leftButton.frame = CGRect.init(x: 15.0, y: statusBarHeight + 11, width: 20.0, height: 20.0)
        leftButton.setBackgroundImage(UIImage(named: imageName), for: .normal)
        leftButton.addTarget(self, action: #selector(pop), for: .touchUpInside);
        self.view.addSubview(leftButton)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0 , execute: {
            self.view.bringSubviewToFront(leftButton)
        })
    }
    
    // MARK: 设置背景图片
    func setBackgroundImage(imageName: String)
    {
        let background = UIImageView(frame: UIScreen.main.bounds)
        background.clipsToBounds = true
        background.contentMode = .scaleAspectFill
        background.image = UIImage(named: imageName)
        self.view.addSubview(background)
    }
    
    
    @objc func pop()
    {
        self.dismiss(animated: true, completion: nil)
    }
}
