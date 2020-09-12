//
//  HomeViewController.swift
//  feel_english
//
//  Created by erheng on 2019/11/21.
//  Copyright © 2019 deepfeel. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        let label = UILabel(frame: CGRect(x: 200, y: 200, width: 100, height: 100))
        label.backgroundColor = UIColor.red
        label.text = "play video"
        
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nextPage))
        tapGesture.numberOfTouchesRequired = 1
        label.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(label)
        
        let leftBarBtn = UIBarButtonItem(title: "", style: .plain, target: self,action: nil)
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        self.navigationItem.backBarButtonItem = leftBarBtn
    }

    
    @objc func nextPage()
    {
        self.hidesBottomBarWhenPushed = true

        let sub1 = Subtitle(index: 39, startTime: "00:00:00,919", endTime: "00:00:03,039", text: "I heard they fire half of us in the first month.", zhText: "我听说他们第一个月就会解雇一半的人")
        let sub2 = Subtitle(index: 40, startTime: "00:00:03,039", endTime: "00:00:04,759", text:  "Oh, yeah, yeah, I heard that, too.", zhText: "没错 我也听说了")
        let sub3 = Subtitle(index: 41, startTime: "00:00:04,759", endTime: "00:00:06,620", text:  "We should stick together.", zhText: "我们应该团结起来")
        let sub4 = Subtitle(index: 42, startTime: "00:00:06,620", endTime: "00:00:09,080", text:  "Uh, I'm Lili. Maia.", zhText: "我叫莉莉  玛娅")
        let sub5 = Subtitle(index: 43, startTime: "00:00:09,080", endTime: "00:00:10,580", text:  "Uh, pretty ring.", zhText: "戒指真好看")
        let sub6 = Subtitle(index: 44, startTime: "00:00:10,580", endTime: "00:00:11,790", text:  "What is it?", zhText: "什么戒指")
        let sub7 = Subtitle(index: 45, startTime: "00:00:11,790", endTime: "00:00:13,750", text:  "Oh, it's a rosary ring.", zhText: "这是念珠戒指")
        let sub8 = Subtitle(index: 46, startTime: "00:00:13,750", endTime: "00:00:14,960", text:  "Are you religious?", zhText: "你信教吗")
        let sub9 = Subtitle(index: 47, startTime: "00:00:14,960", endTime: "00:00:16,790", text:  "No, no.", zhText: "不 不信")
        let sub10 = Subtitle(index: 48, startTime: "00:00:16,790", endTime: "00:00:18,040", text:  "Just nervous.", zhText: "只是紧张而已")

        var subs: [Subtitle] = [Subtitle]()
        subs.append(sub1)
        subs.append(sub2)
        subs.append(sub3)
        subs.append(sub4)
        subs.append(sub5)
        subs.append(sub6)
        subs.append(sub7)
        subs.append(sub8)
        subs.append(sub9)
        subs.append(sub10)


        var movieClipModel = [MovieClipModel]()
        
        movieClipModel.append(MovieClipModel(id: 1, title: "测试视频", describe: "测试视频",
                                             link: "http://video.mengxsh.com/92784b4e23764b9aa7e677f410bca71c/c1df8285a6af499889c30dbd1b1c04a8-b15d28da26a3185fcda5f63195ab0114-ld.mp4", coverImage: "http://video.mengxsh.com/92784b4e23764b9aa7e677f410bca71c/snapshots/14c511c9038a4a7c81e66a82675b4de9-00002.jpg",
                                             blink: [""], tags: [""], shareNum: 324, subtitles: subs))
        
        movieClipModel.append(MovieClipModel(id: 1, title: "测试视频", describe: "测试视频", 
                link: "http://video.mengxsh.com/3d5098f7fdf5437db8445fe3219815d4/7934e13f3e2a42dcaafa46739262c2ec-02f67c80b69686835b8ad83c00abebf4-ld.mp4", 
                coverImage: "http://video.mengxsh.com/3d5098f7fdf5437db8445fe3219815d4/snapshots/d141cec65b0049038d9197ae723d0a8c-00002.jpg", 
                blink: [""], tags: [""], shareNum: 237, subtitles: subs))
        
        
        movieClipModel.append(MovieClipModel(id: 1, title: "测试视频", describe: "测试视频", 
                link: "http://video.mengxsh.com/029e69d6fcab4b789563daa6d8cba2ec/4c72f99291da4f5380e2462a67d56ccb-51a7ab0c9b8cca3be5067bf35340c483-ld.mp4", 
                coverImage: "http://video.mengxsh.com/029e69d6fcab4b789563daa6d8cba2ec/snapshots/dcd5ee2279c84a148f2c67528dc894d4-00003.jpg", 
                blink: [""], tags: [""], shareNum: 984, subtitles: subs))
        
        movieClipModel.append(MovieClipModel(id: 1, title: "测试视频", describe: "测试视频", 
                link: "http://video.mengxsh.com/cba1727597a64669b5420125ac57f400/dc04ac58ba7641f0a1d06eeaacf653e4-cad3975a3fd6489687b9f95dae44824f-ld.mp4", 
                coverImage: "", blink: [""], tags: [""], shareNum: 32, subtitles: subs))
        
        movieClipModel.append(MovieClipModel(id: 1, title: "测试视频", describe: "测试视频", 
                link: "http://video.mengxsh.com/05e194e226c84d1c81cf4fd37fd14136/2567d85a3edb4825a1ef144bd6f9fce0-64f554b30b4d64da59c214456e6aa74b-ld.mp4", 
                coverImage: "", blink: [""], tags: [""], shareNum: 653, subtitles: subs))
        
        
        movieClipModel.append(MovieClipModel(id: 1, title: "测试视频", describe: "测试视频", 
                link: "http://video.mengxsh.com/8dd055e6faf4479496fc42b4a2ee43d9/311adc1ed6314195af1966d05cb45bd5-49ca3c3394b0bac5fe96a4104bc3f5a5-ld.mp4", 
                coverImage: "", blink: [""], tags: [""], shareNum: 9237, subtitles: subs))
        
        movieClipModel.append(MovieClipModel(id: 1, title: "测试视频", describe: "测试视频",
                link: "http://video.mengxsh.com/84f5059e6ae64c3890e9ad59b2d679ee/11e7da080b2249cbb8adaa42610d0753-a2c3e57b8c2d4ece7442746d83bdb994-ld.mp4", 
                coverImage: "", blink: [""], tags: [""], shareNum: 421, subtitles: subs))
        
        
        let controller = VideoListViewController(movieClips: movieClipModel, currentIndex: 0, page: 1, size: 3, uid: "cesshdfsaf")
        self.navigationController?.pushViewController(controller, animated: true)
        
        self.hidesBottomBarWhenPushed = false
    }
}
