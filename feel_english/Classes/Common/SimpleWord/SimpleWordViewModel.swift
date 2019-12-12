//
// Created by erheng on 2019/12/5.
// Copyright (c) 2019 deepfeel. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxRelay

class SimpleWordViewModel
{
    private let provider: MoyaProvider<WordRequest>?
    private let disposeBag: DisposeBag = DisposeBag()
    var simpleWord: Observable<SimpleWordModel>?

    init(word: PublishRelay<String>)
    {
        provider = MoyaProvider()
        self.simpleWord = word.filter( { !$0.isEmpty}).flatMapFirst({ w in
            self.getSimpleWordInfo(of: w)
        })
    }


    func getSimpleWordInfo(of word: String) -> Observable<SimpleWordModel>
    {
        return self.provider!.rx.request(WordRequest.simpleWord(word: word))
                .mapObject(type: result<SimpleWordModel>.self)
                .map({ result in
                    result.data!
                })
                .asObservable()
                .catchError({ error in
                    return Observable<SimpleWordModel>.empty()
                })
    }
}
