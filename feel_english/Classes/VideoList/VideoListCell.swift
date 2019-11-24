//
//  VideoListCell.swift
//  feel_english
//
//  Created by erheng on 2019/11/22.
//  Copyright © 2019 deepfeel. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import SnapKit

typealias OnPlayerReady = () -> Void

let COMMENT_TAP_ACTION: Int = 3000
let SHARE_TAP_ACTION: Int = 4000

// MARk: - 自定义视频列表单元格
class VideoListCell: UITableViewCell
{
    var container: UIView = UIView()
    var pauseIcon: UIImageView = UIImageView(image: UIImage(named: "icon_play_pause"))
    var playerStatusBar: UIView = UIView()
    var singleTapGesture: UITapGestureRecognizer?
    var lastTapTime: TimeInterval = 0
    var lastTapPoint: CGPoint = .zero
    
    var movieClipModel: MovieClipModel? = nil
    
    var playerView: VideoPlayerView = VideoPlayerView()
    var onPlayerReady: OnPlayerReady?
    var isPlayerReady: Bool = false
    
    // MARK: some subview
        
    // 点赞按钮
    var favorite: FavoriteView = FavoriteView()
    var favoriteNum: UILabel = UILabel()
    // 分享按钮
    
    // listen
    
    // write
    
    // speed
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.lastTapTime = 0
        self.lastTapPoint = .zero
        self.initSubViews()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubViews()
    {
        self.playerView.delegate = self
        self.contentView.addSubview(playerView)
        self.contentView.addSubview(container)
        
        // 设置点击事件
        self.singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture(sender: )))
        container.addGestureRecognizer(singleTapGesture!)
        
        // 设置暂停图标
        pauseIcon.contentMode = .center
        pauseIcon.layer.zPosition = 3
        pauseIcon.isHidden = true
        container.addSubview(pauseIcon)
        
        
        // 设置player status bar
        playerStatusBar.backgroundColor = UIColor.white
        playerStatusBar.isHidden = true
        container.addSubview(playerStatusBar)
        
        // 设置分享
        
        
        // 设置点赞
        container.addSubview(favorite)
        
        favoriteNum.text = "320"
        favoriteNum.textColor = UIColor.white
        // TODO: 公共参数
        favoriteNum.font = UIFont.systemFont(ofSize: 10.0)
        container.addSubview(favoriteNum)
        
        // 设置listen
        
        // 设置write
        
        // 设置speed
        
    }
    
    
    // 添加子视图
    override func layoutSubviews()
    {
        super.layoutSubviews()
        container.frame = self.bounds
        pauseIcon.frame = CGRect(x: self.bounds.midX - 50, y: 210, width: 100, height: 100)
        
        // 底部安全区域
        let safeAreaBottomHeight: CGFloat = (UIScreen.main.bounds.height >= 812.0 && UIDevice.current.model == "iPhone"  ? 30 : 0)
        playerStatusBar.frame = CGRect(x: self.bounds.midX - 0.5, y: self.bounds.maxY - 49.5 - safeAreaBottomHeight, width: 1.0, height: 1)
        
        // 设置分享按钮布局
        
        // 设置点赞按钮布局
        favorite.snp.makeConstraints { make in
            make.bottom.equalTo(self).inset(60 + safeAreaBottomHeight);
            make.right.equalTo(self).inset(10);
            make.width.equalTo(50);
            make.height.equalTo(45);
        }
        favoriteNum.snp.makeConstraints { make in
            make.top.equalTo(self.favorite.snp.bottom);
            make.centerX.equalTo(self.favorite);
        }
        // 设置listen
        
        // 设置write
        
        // 设置speed
        
        
    }
    
    
    // 复用单元格， 重新初始化数据
    override func prepareForReuse()
    {
        super.prepareForReuse()
        isPlayerReady = false
        playerView.cancelLoading()
        pauseIcon.isHidden = true
        favorite.resetView()
    }
    
    
    func initMovieClipData(data: MovieClipModel)
    {
        self.movieClipModel = data
        playerView.setPlayerSourceUrl(url: (movieClipModel?.link)!)

        // 分享和点赞数据
    }
    
    
    func play()
    {
        playerView.play()
    }
    
    func pause()
    {
        playerView.pause()
    }
    
    func replay()
    {
        playerView.replay()
    }
}


extension VideoListCell
{
    @objc func handleGesture(sender: UITapGestureRecognizer)
    {
        switch sender.view?.tag
        {
            case COMMENT_TAP_ACTION:
                // 显示评论
                break
            case SHARE_TAP_ACTION:
                // 显示分享
                break
            default:
                //获取点击坐标，用于设置爱心显示位置
                let point = sender.location(in: container)
                //获取当前时间
                let time = CACurrentMediaTime()
                //判断当前点击时间与上次点击时间的时间间隔
                if (time - lastTapTime) > 0.25
                {
                    //推迟0.25秒执行单击方法
                    self.perform(#selector(singleTapAction), with: nil, afterDelay: 0.25)
                }
                else
                {
                    //取消执行单击方法
                    NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(singleTapAction), object: nil)
                    //执行连击显示爱心的方法
                    showLikeViewAnim(newPoint: point, oldPoint: lastTapPoint)
                }
                //更新上一次点击位置
                lastTapPoint = point
                //更新上一次点击时间
                lastTapTime = time
                break
                
        }
    }
    
    // 单击暂停
    @objc func singleTapAction()
    {
        showPauseViewAnim(rate: playerView.rate())
        playerView.updatePlayerState()
    }
}

extension VideoListCell
{
    // 显示暂停动画
    func showPauseViewAnim(rate:CGFloat)
    {
        if rate == 0
        {
            UIView.animate(withDuration: 0.25, animations: {
                self.pauseIcon.alpha = 0.0
            }) { finished in
                self.pauseIcon.isHidden = true
            }
        }
        else
        {
            pauseIcon.isHidden = false
            pauseIcon.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
            pauseIcon.alpha = 1.0
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
                self.pauseIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }) { finished in
            }
        }
    }
    
    // 双击点赞动画
    func showLikeViewAnim(newPoint:CGPoint, oldPoint:CGPoint)
    {
        
    }
    
    
    // 加载动画
    func startLoadingPlayItemAnim(_ isStart:Bool = true)
    {
        if isStart
        {
            playerStatusBar.backgroundColor = UIColor.white
            playerStatusBar.isHidden = false
            playerStatusBar.layer.removeAllAnimations()
            
            let animationGroup = CAAnimationGroup.init()
            animationGroup.duration = 0.5
            animationGroup.beginTime = CACurrentMediaTime()
            animationGroup.repeatCount = .infinity
            animationGroup.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
            
            let scaleAnim = CABasicAnimation.init()
            scaleAnim.keyPath = "transform.scale.x"
            scaleAnim.fromValue = 1.0
            scaleAnim.toValue = 1.0 * UIScreen.main.bounds.width
            
            let alphaAnim = CABasicAnimation.init()
            alphaAnim.keyPath = "opacity"
            alphaAnim.fromValue = 1.0
            alphaAnim.toValue = 0.2
            
            animationGroup.animations = [scaleAnim, alphaAnim]
            playerStatusBar.layer.add(animationGroup, forKey: nil)
        }
        else
        {
            playerStatusBar.layer.removeAllAnimations()
            playerStatusBar.isHidden = true
        }
    }
}


extension VideoListCell: VideoPlayerUpdateDelegate
{
    func onProgressUpdate(current: CGFloat, total: CGFloat)
    {
        // 视频播放的时间变化
//        print("视频播放时间" + current.description)
    }
    
    func onPlayItemStatusUpdate(status: AVPlayerItem.Status)
    {
        switch status
        {
            case .unknown:
                startLoadingPlayItemAnim()
                break
            case .readyToPlay:
                self.backgroundColor = UIColor.black
                self.isPlayerReady = true
                self.onPlayerReady?()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                    self.startLoadingPlayItemAnim(false)
                })
                break
            case .failed:
                startLoadingPlayItemAnim(false)
                break
            default:
                break
        }
    }
    
    
}
