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


    
    // MARK: - 可以提取到BaseViewController
    func setBackgroundImage(imageName: String)
    {
        let background = UIImageView(frame: UIScreen.main.bounds)
        background.clipsToBounds = true
        background.contentMode = .scaleAspectFill
        background.image = UIImage(named: imageName)
        self.view.addSubview(background)
    }
}
