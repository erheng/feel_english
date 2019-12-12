//
//  WordRequest.swift
//  feel_english
//
//  Created by erheng on 2019/12/3.
//  Copyright © 2019 deepfeel. All rights reserved.
//

import Foundation
import Moya

enum WordRequest
{
    case simpleWord(word: String)
    case wordInfo(word: String)
}


extension WordRequest: TargetType
{
    var path: String {
        switch self
        {
            case .simpleWord(let words):
                return "/simple/word/" + words
            case .wordInfo:
                return "/word/info"
        }
    }

    
    var sampleData: Data {
        return "{}".data(using: .utf8)!
    }
    
    var task: Task {
        switch self
        {
            case .simpleWord(let word), .wordInfo(let word):
                return .requestParameters(parameters: ["word": word], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
