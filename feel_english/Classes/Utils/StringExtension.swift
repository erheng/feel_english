//
//  StringExtension.swift
//  feel_english
//
//  Created by erheng on 2019/11/22.
//  Copyright © 2019 deepfeel. All rights reserved.
//

import Foundation

extension String
{
    static func format(decimal:Float, _ maximumDigits:Int = 1, _ minimumDigits:Int = 1) ->String?
    {
        let number = NSNumber(value: decimal)
        let numberFormatter = NumberFormatter()
        //设置小数点后最多2位
        numberFormatter.maximumFractionDigits = maximumDigits
        //设置小数点后最少2位（不足补0）
        numberFormatter.minimumFractionDigits = minimumDigits
        return numberFormatter.string(from: number)
    }
    
    func urlScheme(scheme:String) -> URL?
    {
        if let url = URL.init(string: self)
        {
            var components = URLComponents.init(url: url, resolvingAgainstBaseURL: false)
            components?.scheme = scheme
            return components?.url
        }
        return nil
    }
    
    static func formatCount(count:NSInteger) -> String
    {
        if count < 10000
        {
            return String.init(count)
        }
        else
        {
            return (String.format(decimal: Float(count)/Float(10000)) ?? "0") + "w"
        }
    }
}
