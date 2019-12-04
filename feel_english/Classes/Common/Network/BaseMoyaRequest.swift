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
        return URL(string: "https://www.91bda.com")!
    }
    
    // 请求类型
    public var method: Moya.Method
    {
        return .get
    }
}
