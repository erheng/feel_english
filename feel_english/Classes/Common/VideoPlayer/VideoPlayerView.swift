//
//  VideoPlayerView.swift
//  feel_english
//
//  Created by erheng on 2019/11/22.
//  Copyright © 2019 deepfeel. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MobileCoreServices


// MARK: - 自定义Delegate，用于进度、播放状态更新回调
protocol AVPlayerUpdateDelegate: NSObjectProtocol
{
    // MARK: 播放进度更新回调方法
    func onProgressUpdate(current: CGFloat, total: CGFloat)
    // MARK: 播放状态更新回调方法
    func onPlayItemStatusUpdate(status: AVPlayerItem.Status)
}


// MARK: - 自定义的Video Player视图
class VideoPlayerView: UIView
{
    // 代理
    var delegate: AVPlayerUpdateDelegate?
    // 视频路径
    var sourceURL: URL?
    // 路径Scheme
    var sourceScheme: String?
    // 视频资源
    var urlAsset: AVURLAsset?
    // 视频资源载体
    var playerItem: AVPlayerItem?
    // 视频播放器
    var player: AVPlayer?
    // 视频播放器图形化载体
    var playerLayer: AVPlayerLayer = AVPlayerLayer()
    // 视频播放器周期性调用的观察者
    var timeObserver: Any?
    // 视频缓冲数据
    var data: Data?
    // 视频下载session
    var session: URLSession?
    // 视频下载NSURLSessionDataTask
    var task: URLSessionDataTask?
    // 视频下载请求响应
    var response: HTTPURLResponse?
    // 存储AVAssetResourceLoadingRequest的数组
    var pendingRequests = [AVAssetResourceLoadingRequest]()
    // 缓存文件key值
    var cacheFileKey: String?
    // 查找本地视频缓存数据的NSOperation
    var queryCacheOperation: Operation?
    var cancelLoadingQueue: DispatchQueue?
    
    
    init()
    {
        super.init(frame: UIScreen.main.bounds)
        initSubView()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubView()
    {
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        self.layer.addSublayer(self.playerLayer)
        
        addProgressObserver()
        
        cancelLoadingQueue = DispatchQueue(label: "ai.deepfell")
    }
    
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        playerLayer.frame = self.layer.bounds
        CATransaction.commit()
    }
    
    func setPlayerSourceUrl(url:String)
    {
        sourceURL = URL(string: url)
        
        let components = URLComponents(url: sourceURL!, resolvingAgainstBaseURL: false)
        sourceScheme = components?.scheme
        cacheFileKey = sourceURL?.absoluteString
        
        queryCacheOperation = VideoCacheManager.shared().queryURLFromDiskMemory(key: cacheFileKey ?? "", cacheQueryCompletedBlock: { [weak self] (data, hasCache) in
                DispatchQueue.main.async {[weak self] in
                if !hasCache
                {
                    self?.sourceURL = self?.sourceURL?.absoluteString.urlScheme(scheme: "streaming")
                }
                else
                {
                    self?.sourceURL = URL(fileURLWithPath: data as? String ?? "")
                }
                if let url = self?.sourceURL
                {
                    self?.urlAsset = AVURLAsset(url: url, options: nil)
                    self?.urlAsset?.resourceLoader.setDelegate(self, queue: DispatchQueue.main)
                    if let asset = self?.urlAsset
                    {
                        self?.playerItem = AVPlayerItem(asset: asset)
                        self?.playerItem?.addObserver(self!, forKeyPath: "status", options: [.initial, .new], context: nil)
                        self?.player = AVPlayer(playerItem: self?.playerItem)
                        self?.playerLayer.player = self?.player
                        
                        self?.changeLayerPositionAndSize()
                        self?.player?.replaceCurrentItem(with: self?.playerItem)
                        self?.addProgressObserver()
                    }
                }
            }
        }, exten: "mp4")
    }
    
    // 根据视频大小修改UIView的大小 TODO: M3U8视频格式获取大小不起作用, 视频大小由后台参数返回
    private func changeLayerPositionAndSize()
    {
        var videoSize: CGSize?
        let tracks: [AVAssetTrack] = self.urlAsset?.tracks ?? []
        for track in tracks
        {
           if track.mediaType.rawValue == "vide"
           {
               videoSize = track.naturalSize
           }
        }
        // 计算视频在手机的显示高度
        let videoHeight = ( UIScreen.main.bounds.width * 2 ) / (videoSize?.width ?? 0.0)  * (videoSize?.height ?? 1.0)
        if videoHeight < 500
        {
            self.frame = CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: videoHeight)
        }
    }
    
    func cancelLoading()
    {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        playerLayer.isHidden = true
        CATransaction.commit()
        
        queryCacheOperation?.cancel()
        removeObserver()
        self.pause()
        
        player = nil
        playerItem = nil
        playerLayer.player = nil
        
        cancelLoadingQueue?.async { [weak self] in
            self?.urlAsset?.cancelLoading()
            
            self?.task?.cancel()
            self?.task = nil
            self?.data = nil
            self?.response = nil
            
            for loadingRequest in self?.pendingRequests ?? [] {
                if !loadingRequest.isFinished
                {
                    loadingRequest.finishLoading()
                }
            }
            self?.pendingRequests.removeAll()
        }
        
    }
    
    func play()
    {
        AVPlayerManager.shared().play(player: player!)
    }
    
    func pause()
    {
        AVPlayerManager.shared().pause(player: player!)
    }
    
    func replay()
    {
        AVPlayerManager.shared().replay(player: player!)
    }
    
    func rate() -> CGFloat
    {
        return CGFloat(player?.rate ?? 0)
    }
    
    deinit
    {
        removeObserver()
    }
    
}


// MARK: - video status Observe
extension VideoPlayerView
{
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if keyPath == "status"
        {
            if playerItem?.status == .readyToPlay
            {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                playerLayer.isHidden = false
                CATransaction.commit()
            }
            delegate?.onPlayItemStatusUpdate(status: playerItem?.status ?? AVPlayerItem.Status.unknown)
        }
        else
        {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // 定期观察视频的播放时间
    private func addProgressObserver()
    {
        timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 600), queue: DispatchQueue.main, using: {
            [weak self] time in
            let current = CMTimeGetSeconds(time)
            let total = CMTimeGetSeconds(self?.playerItem?.duration ?? CMTime())
            if total == current
            {
                self?.replay()
            }
            self?.delegate?.onProgressUpdate(current: CGFloat(current), total: CGFloat(total))
        })
    }
    
    
    func removeObserver()
    {
        playerItem?.removeObserver(self, forKeyPath: "status")
        if let observer = timeObserver
        {
            player?.removeTimeObserver(observer)
        }
    }
}



extension VideoPlayerView: URLSessionTaskDelegate, URLSessionDataDelegate
{
    
}


extension VideoPlayerView: AVAssetResourceLoaderDelegate
{
    
}
