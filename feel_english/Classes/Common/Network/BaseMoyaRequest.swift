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
        return URL(string: "http://192.168.3.70:7182")!
    }
    
    // 请求类型
    public var method: Moya.Method
    {
        return .get
    }
}
