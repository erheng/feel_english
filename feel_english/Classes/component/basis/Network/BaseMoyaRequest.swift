//
//  BaseMoyaRequest.swift
//  feel_english
//
//  Created by erheng on 2019/12/3.
//  Copyright © 2019 deepfeel. All rights reserved.
//

import Foundation
import Moya

extension TargetType
{
    var baseURL: URL {
        return URL(string: "http://47.95.146.109/feel")!
    }
    
    // 请求类型
    public var method: Moya.Method
    {
        return .get
    }
}
