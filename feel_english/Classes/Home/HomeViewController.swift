//
//  HomeViewController.swift
//  feel_english
//
//  Created by erheng on 2019/11/21.
//  Copyright © 2019 deepfeel. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        let label = UILabel(frame: CGRect(x: 100, y: 200, width: 100, height: 100))
        label.backgroundColor = UIColor.red
        label.text = "play video"
        
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nextPage))
        tapGesture.numberOfTouchesRequired = 1
        label.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(label)
    }
    
    
    @objc func nextPage()
    {
        self.hidesBottomBarWhenPushed = true
        
        var movieClipModel = [MovieClipModel]()
        
        movieClipModel.append(MovieClipModel(id: 1, title: "测试视频", describe: "测试视频", link: "http://video.mengxsh.com/92784b4e23764b9aa7e677f410bca71c/c1df8285a6af499889c30dbd1b1c04a8-b15d28da26a3185fcda5f63195ab0114-ld.mp4", blink: [""], tags: [""]))
        
        movieClipModel.append(MovieClipModel(id: 1, title: "测试视频", describe: "测试视频", link: "http://video.mengxsh.com/3d5098f7fdf5437db8445fe3219815d4/7934e13f3e2a42dcaafa46739262c2ec-02f67c80b69686835b8ad83c00abebf4-ld.mp4", blink: [""], tags: [""]))
        
        
        movieClipModel.append(MovieClipModel(id: 1, title: "测试视频", describe: "测试视频", link: "http://video.mengxsh.com/029e69d6fcab4b789563daa6d8cba2ec/4c72f99291da4f5380e2462a67d56ccb-51a7ab0c9b8cca3be5067bf35340c483-ld.mp4", blink: [""], tags: [""]))
        
        
        let controller = VideoListViewController(movieClips: movieClipModel, currentIndex: 0, page: 1, size: 3, uid: "cesshdfsaf")
        self.navigationController?.pushViewController(controller, animated: true)
        
        self.hidesBottomBarWhenPushed = false
    }
}
