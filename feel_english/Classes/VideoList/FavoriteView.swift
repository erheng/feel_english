//
//  FavoriteView.swift
//  feel_english
//
//  Created by erheng on 2019/11/24.
//  Copyright © 2019 deepfeel. All rights reserved.
//

import UIKit
import Foundation

class FavoriteView: UIView
{
    var favoriteBeforeImage = UIImageView(image: UIImage(named: "icon_home_like_before"))
    var favoriteAfterImage = UIImageView(image: UIImage(named: "icon_home_like_after"))
    
    public private(set) var LIKE_BEFORE_TAP_ACTION: Int = 1000
    public private(set) var LIKE_AFTER_TAP_ACTION: Int = 2000
    
    init()
    {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 45)))
        self.initSubView()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.initSubView()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubView()
    {
        favoriteBeforeImage.frame = self.frame
        favoriteBeforeImage.contentMode = .center
        favoriteBeforeImage.isUserInteractionEnabled = true
        favoriteBeforeImage.tag = self.LIKE_BEFORE_TAP_ACTION
        favoriteBeforeImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGesture(sender:))))
        self.addSubview(favoriteBeforeImage)
        
        favoriteAfterImage.frame = self.frame
        favoriteAfterImage.contentMode = .center
        favoriteAfterImage.isUserInteractionEnabled = true
        favoriteAfterImage.tag = self.LIKE_AFTER_TAP_ACTION
        favoriteAfterImage.isHidden = true
        favoriteAfterImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGesture(sender:))))
        self.addSubview(favoriteAfterImage)
    }
    
    @objc func handleGesture(sender: UIGestureRecognizer)
    {
        switch sender.view?.tag
        {
            case LIKE_BEFORE_TAP_ACTION:
                startLikeAnim(isLike: true)
                break
            case LIKE_AFTER_TAP_ACTION:
                startLikeAnim(isLike: false)
                break
            default:
                break
        }
    }
    
    func startLikeAnim(isLike: Bool)
    {
        favoriteBeforeImage.isUserInteractionEnabled = false
        favoriteAfterImage.isUserInteractionEnabled  = false
        
        // TODO: 公共参数
        let ColorThemeRed: UIColor = UIColor(red: 241.0, green: 47.0, blue: 84.0, alpha: 1.0)
        if  isLike
        {
            let length: CGFloat = 30
            let duration: CGFloat = 0.5
            for index in 0..<6
            {
                let layer = CAShapeLayer()
                layer.position = favoriteBeforeImage.center
                layer.fillColor = ColorThemeRed.cgColor
                
                let startPath = UIBezierPath()
                startPath.move(to: CGPoint(x: -2, y: -length))
                startPath.addLine(to: CGPoint(x: 2, y: -length))
                startPath.addLine(to: .zero)
                
                let endPath = UIBezierPath()
                endPath.move(to: CGPoint(x: -2, y: -length))
                endPath.addLine(to: CGPoint(x: 2, y: -length))
                endPath.addLine(to: CGPoint(x: 0, y: -length))
                
                
                layer.path = startPath.cgPath
                layer.transform = CATransform3DMakeRotation(.pi / 3.0 * CGFloat(index), 0.0, 0.0, 1.0)
                self.layer.addSublayer(layer)
                
                let group = CAAnimationGroup()
                group.isRemovedOnCompletion = false
                group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                group.fillMode = CAMediaTimingFillMode.forwards
                group.duration = CFTimeInterval(duration)
                
                let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
                scaleAnim.fromValue = 0.0
                scaleAnim.toValue = 1.0
                scaleAnim.duration = CFTimeInterval(duration * 0.2)
                
                let pathAnim = CABasicAnimation(keyPath: "path")
                pathAnim.fromValue = layer.path
                pathAnim.toValue = endPath.cgPath
                pathAnim.beginTime = CFTimeInterval(duration * 0.2)
                pathAnim.duration = CFTimeInterval(duration * 0.8)
                
                group.animations = [scaleAnim, pathAnim]
                layer.add(group, forKey: nil)
            }
            
            favoriteAfterImage.isHidden = false
            favoriteAfterImage.alpha = 0.0
            favoriteAfterImage.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5).concatenating(CGAffineTransform.init(rotationAngle: .pi / 3 * 2))
            UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
                self.favoriteBeforeImage.alpha = 0.0
                self.favoriteAfterImage.alpha = 1.0
                self.favoriteAfterImage.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform.init(rotationAngle: 0))
            }) { finished in
                self.favoriteBeforeImage.alpha = 1.0
                self.favoriteBeforeImage.isUserInteractionEnabled = true
                self.favoriteAfterImage.isUserInteractionEnabled = true
            }
        }
        else
        {
            favoriteAfterImage.alpha = 1.0
            favoriteAfterImage.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform.init(rotationAngle: 0))
            UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseIn, animations: {
                self.favoriteAfterImage.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1).concatenating(CGAffineTransform.init(rotationAngle: .pi/4))
            }) { finished in
                self.favoriteAfterImage.isHidden = true
                self.favoriteBeforeImage.isUserInteractionEnabled = true
                self.favoriteAfterImage.isUserInteractionEnabled = true
            }
        }
    }
    
    func resetView()
    {
        favoriteBeforeImage.isHidden = false
        favoriteAfterImage.isHidden = true
        self.layer.removeAllAnimations()
    }
}
