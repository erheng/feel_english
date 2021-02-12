//
//  MovieClipModel.swift
//  feel_english
//
//  Created by erheng on 2019/11/22.
//  Copyright © 2019 deepfeel. All rights reserved.
//

import Foundation

struct MovieClipModel
{
    let id: Int?
    let title: String?
    let describe: String?
    let link: String?
    let coverImage: String?
    let blink: [String]?
    let tags: [String]?
    let shareNum: Int?
    let subtitles: [Subtitle]

    public func search(for millisecond: Int) -> Subtitle?
    {
        let result = subtitles.first(where: { subtitle -> Bool in
            if subtitle.startTime <= millisecond && subtitle.endTime >= millisecond
            {
                return true
            }
            return false
        })
        return result
    }
}


struct Subtitle
{
    var index: Int
    var startTime: CLongLong
    var endTime: CLongLong
    var text: String
    var zhText: String

    init(index: Int, startTime: String, endTime: String, text: String, zhText: String)
    {
        self.index = index
        self.startTime = Subtitle.parseSubtitleDuration(for: startTime)
        self.endTime = Subtitle.parseSubtitleDuration(for: endTime)
        self.text = text
        self.zhText = zhText
    }

    static func parseSubtitleDuration(for time: String) -> CLongLong
    {
        var hour: Int = 0
        var minute: Int = 0
        var second: Int = 0
        var millisecond: Int = 0

        let sub: [Substring] = time.split(separator: ":")
        for index in 0...2
        {
           switch index
           {
               case 0:
                   hour = Int(sub[index]) ?? hour
                   break
               case 1:
                   minute = Int(sub[index]) ?? minute
                   break
               case 2:
                   let substrings: [Substring] = sub[index].split(separator: ",")
                   second = Int(substrings[0]) ?? second
                   millisecond = Int(substrings[1]) ?? millisecond
                   break
               default:
                   break
           }

        }
        let millisecondTime: CLongLong = CLongLong(hour * 3600 * 1000 + minute * 60 * 1000 + second * 1000 + millisecond)
        return millisecondTime
    }
}