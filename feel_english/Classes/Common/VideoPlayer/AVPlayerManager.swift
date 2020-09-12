//
//  AVPlayerManager.swift
//  feel_english
//
//  Created by erheng on 2019/11/22.
//  Copyright © 2019 deepfeel. All rights reserved.
//

import Foundation
import AVFoundation

class AVPlayerManager: NSObject
{
    var playerArray = [AVPlayer]()
    
    private static let instance = { () -> AVPlayerManager in
        return AVPlayerManager()
    }()
    
    private override init()
    {
        super.init()
    }
    
    class func shared() -> AVPlayerManager
    {
        return instance
    }
    
    func play(player: AVPlayer)
    {
        self.pauseAll()
        if !playerArray.contains(player)
        {
            playerArray.append(player)
        }
        player.play()
    }
    
    func pause(player:AVPlayer)
    {
        if playerArray.contains(player)
        {
            player.pause()
        }
    }
    
    func pauseAll()
    {
        for object in playerArray
        {
            object.pause()
        }
    }
    
    
    func replay(player: AVPlayer)
    {
        self.pauseAll()
        
        if playerArray.contains(player)
        {
            player.seek(to: CMTime.zero)
            play(player: player)
        }
        else
        {
            playerArray.append(player)
            play(player: player)
        }
    }
}
