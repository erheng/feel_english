//
//  LearnPleanViewController.swift
//  feel_english
//
//  Created by erheng on 2019/11/21.
//  Copyright © 2019 deepfeel. All rights reserved.
//

import UIKit


class LearnPleanViewController: UIViewController
{
    let array = ["crs","grs","nrs"]
    let callName = "callNativeMethond"

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(button)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    lazy var button : UIButton = {
            let object = UIButton()
            object.backgroundColor = UIColor.red
            object.center = CGPoint.init(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
            object.bounds = CGRect.init(x: 0, y: 0, width: 200, height: 200)
        
            return object
        }()
}
