//
//  ObservableTypeExtension.swift
//  feel_english
//
//  Created by erheng on 2019/12/4.
//  Copyright © 2019 deepfeel. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

public extension ObservableType where Element == Response
{
    func mapObject<T: BaseMappable>(type: T.Type, context: MapContext? = nil) -> Observable<T>
    {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapObject(type, context: context))
        }
    }

    func mapArray<T: BaseMappable>(type: T.Type, context: MapContext? = nil) -> Observable<[T]>
    {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapArray(type, context: context))
        }
    }
  

    func mapObject<T: BaseMappable>(_ type: T.Type, atKeyPath keyPath: String, context: MapContext? = nil) -> Observable<T>
    {
        return flatMap { response -> Observable<T> in
          return Observable.just(try response.mapObject(T.self, atKeyPath: keyPath, context: context))
        }
    }


    
    func mapArray<T: BaseMappable>(_ type: T.Type, atKeyPath keyPath: String, context: MapContext? = nil) -> Observable<[T]>
    {
        return flatMap { response -> Observable<[T]> in
                return Observable.just(try response.mapArray(T.self, atKeyPath: keyPath, context: context))
        }
    }
}
