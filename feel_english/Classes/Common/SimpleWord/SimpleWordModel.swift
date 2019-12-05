//
//  SimpleWordModel.swift
//  feel_english
//
//  Created by erheng on 2019/12/3.
//  Copyright © 2019 deepfeel. All rights reserved.
//

import Foundation
import ObjectMapper

struct SimpleWordModel: Mappable
{
    var simpleWord: String?
    var USPhonetic: String?
    var UKPhonetic: String?
    var USPhoneticLink: String?
    var UKPhoneticLink: String?
    var translation: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map)
    {
        simpleWord <- map["word"]
        USPhonetic <- map["usPhonetic"]
        UKPhonetic <- map["ukPhonetic"]
        USPhoneticLink <- map["usVoice"]
        UKPhoneticLink <- map["ukVoice"]
        translation <- map["translation"]
    }
}



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