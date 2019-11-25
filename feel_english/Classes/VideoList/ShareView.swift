//
//  ShareView.swift
//  feel_english
//
//  Created by erheng on 2019/11/24.
//  Copyright © 2019 deepfeel. All rights reserved.
//

import UIKit

class ShareView: UIView
{
    var shareImage: UIImageView = UIImageView(image: UIImage(named: "icon_home_share"))
    
    init()
    {
        super.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 50, height: 45)))
        initSubView()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        initSubView()
    }
    
    
    
    func initSubView()
    {
        shareImage.frame = self.frame
        shareImage.contentMode = .center
        shareImage.isUserInteractionEnabled = true
        shareImage.tag = SHARE_TAP_ACTION
        shareImage.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGesture(sender:))))
        self.addSubview(shareImage)
    }
    
    
    @objc func handleGesture(sender: UITapGestureRecognizer)
    {
        
    }
}
