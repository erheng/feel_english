//
//  MoyaResponseExtension.swift
//  feel_english
//
//  Created by erheng on 2019/12/4.
//  Copyright © 2019 deepfeel. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import RxSwift

public extension Response
{
    // 这一个主要是将JSON解析为单个的Model
    func mapObject<T: BaseMappable>(_ type: T.Type, context: MapContext? = nil) throws -> T
    {
        if self.statusCode < 400
        {
            guard let object = Mapper<T>(context: context).map(JSONObject: try mapJSON()) else {
               throw MoyaError.jsonMapping(self)
             }
            return object
        }
        
        do
        {
            let serviceError = Mapper<ServiceError>().map(JSONObject: try mapJSON())
            throw serviceError!
        }
        catch
        {
            if error is ServiceError
            {
                throw error
            }
            let serviceError = ServiceError(code: -1, message: "服务器开小差，请稍后重试")
            throw serviceError
        }
        
    }

    // 这个主要是将JSON解析成多个Model并返回一个数组
    func mapArray<T: BaseMappable>(_ type: T.Type, context: MapContext? = nil) throws -> [T]
    {
        guard let array = try mapJSON() as? [[String : Any]] else {
          throw MoyaError.jsonMapping(self)
        }
        return Mapper<T>(context: context).mapArray(JSONArray: array)
    }

    func mapObject<T: BaseMappable>(_ type: T.Type, atKeyPath keyPath: String, context: MapContext? = nil) throws -> T
    {
        guard let object = Mapper<T>(context: context).map(JSONObject: (try mapJSON() as? NSDictionary)?.value(forKeyPath: keyPath)) else {
            throw MoyaError.jsonMapping(self)
        }
        return object
    }


    func mapArray<T: BaseMappable>(_ type: T.Type, atKeyPath keyPath: String, context: MapContext? = nil) throws -> [T]
    {
        guard let array = (try mapJSON() as? NSDictionary)?.value(forKeyPath: keyPath) as? [[String : Any]] else {
          throw MoyaError.jsonMapping(self)
        }
        return Mapper<T>(context: context).mapArray(JSONArray: array)
    }
    
}

public extension PrimitiveSequence where Trait == SingleTrait, Element == Response
{
    func mapObject<T: BaseMappable>(type: T.Type) -> Single<T>
    {
        return self.map{ response in
            return try response.mapObject(type)
        }
    }

    func mapArray<T: BaseMappable>(type: T.Type) -> Single<[T]>
    {
        return self.map{ response in
            return try response.mapArray(type)
        }
    }
}
