//
//  NetworkResult.swift
//  feel_english
//
//  Created by erheng on 2019/12/12.
//  Copyright © 2019 deepfeel. All rights reserved.
//

import Foundation
import ObjectMapper


struct result<T: Mappable>: Mappable
{
    var message: String?
    var code: Int?
    var data: T?

    init?(map: Map)
    {
    }

    mutating func mapping(map: Map)
    {
        message <- map["message"]
        code <- map["code"]
        data <- map["data"]
    }
}


struct ServiceError: Mappable
{
    var message: String?
    var code: Int?
    
    init?(map: Map)
    {
    }

    mutating func mapping(map: Map)
    {
        message <- map["message"]
        code <- map["code"]
    }
}
