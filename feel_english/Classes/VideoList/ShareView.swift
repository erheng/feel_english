//
//  ShareView.swift
//  feel_english
//
//  Created by erheng on 2019/11/24.
//  Copyright © 2019 deepfeel. All rights reserved.
//

import UIKit
import SnapKit

class ShareView: UIView
{
    var shareImage: UIImageView = UIImageView(image: UIImage(named: "icon_home_share"))
    var shareNum: String?
    var shareNumLabel: UILabel = UILabel()
    
    init(number: String)
    {
        super.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 50, height: 67)))
        self.shareNum = number
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
        shareImage.contentMode = .center
        shareImage.isUserInteractionEnabled = true
        shareImage.tag = SHARE_TAP_ACTION
        shareImage.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGesture(sender:))))
        self.addSubview(shareImage)

        shareNumLabel.text = self.shareNum
        shareNumLabel.textColor = UIColor.white
        shareNumLabel.font = UIFont.systemFont(ofSize: 10.0)
        self.addSubview(shareNumLabel)


    }

    override func layoutSubviews()
    {
        super.layoutSubviews()

        shareImage.snp.makeConstraints{ make in
            make.top.equalTo(self.snp.top)
            make.centerX.equalTo(self)
            make.width.equalTo(50)
            make.height.equalTo(45)
        }

        shareNumLabel.snp.makeConstraints{ make in
            make.top.equalTo(self.shareImage.snp.bottom)
            make.centerX.equalTo(self)
        }
    }

    @objc func handleGesture(sender: UITapGestureRecognizer)
    {
        
    }
}
