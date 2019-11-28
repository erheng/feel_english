//
//  MeViewController.swift
//  feel_english
//
//  Created by erheng on 2019/11/21.
//  Copyright © 2019 deepfeel. All rights reserved.
//

import UIKit
import AVFoundation
class MeViewController: UIViewController, UIGestureRecognizerDelegate
{
    let simpleWord: SimpleWordView = SimpleWordView()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("添加simple word")
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        simpleWord.show()
    }
}
