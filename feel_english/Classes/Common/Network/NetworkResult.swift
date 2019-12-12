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

struct resultDataOfArray<T: Mappable>: Mappable
{
    var message: String?
    var code: Int?
    var data: [T]?

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


class ServiceError: Error,Mappable
{
    var message: String?
    var code: Int?
    
    init(code: Int, message: String)
    {
        self.code = code
        self.message = message
    }
    
    required init?(map: Map)
    {
    }

    func mapping(map: Map)
    {
        message <- map["message"]
        code <- map["code"]
    }
    
    var localizedDescription: String {
        return "netword request error:  result code: \(String(describing: code)) and message: \(String(describing: message))"
    }
}
