//
// Created by erheng on 2019/12/5.
// Copyright (c) 2019 deepfeel. All rights reserved.
//

import Foundation
import Moya
import RxSwift


extension MoyaProvider: ReactiveCompatible {}

public extension Reactive where Base: MoyaProviderType
{
    func requestWithProgress(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Observable<ProgressResponse>
    {
        let progressBlock: (AnyObserver) -> (ProgressResponse) -> Void = { observer in
            return { progress in
                observer.onNext(progress)
            }
        }

        let response: Observable<ProgressResponse> = Observable.create { [weak base] observer in
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: progressBlock(observer)) { result in
                switch result
                {
                    case .success:
                        observer.onCompleted()
                    case let .failure(error):
                        observer.onError(error)
                }
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }

        // Accumulate all progress and combine them when the result comes
        return response.scan(ProgressResponse()) { last, progress in
            let progressObject = progress.progressObject ?? last.progressObject
            let response = progress.response ?? last.response
            return ProgressResponse(progress: progressObject, response: response)
        }
    }

    func request(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<Response>
    {
        return Single.create { [weak base] single in
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: nil) { result in
                switch result {
                    case let .success(response):
                        single(.success(response))
                    case let .failure(error):
                        single(.error(error))
                }
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }
}