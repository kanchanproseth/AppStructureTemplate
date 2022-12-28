//
//  NewsService.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 06/03/2022.
//

import Foundation
import RxSwift
import Moya


protocol Networkable {
    var provider: MoyaProvider<NewsApi> { get }
    func requestTopHeadline() -> Observable<NewsEntity>
    func requestSearchNews(query: String?,
                           filter: String?,
                           from: String?,
                           to: String?,
                           sortBy: String?) -> Observable<NewsEntity>
}


class NewsService: Networkable {
    
    var provider = MoyaProvider<NewsApi>(plugins: [
        NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    
    func requestTopHeadline() -> Observable<NewsEntity> {
        let request = provider.rx.request(.topHeadline).map(NewsEntity.self)
        return request.asObservable()
    }
    
    func requestSearchNews(query: String?  = nil, filter: String?  = nil, from: String?  = nil, to: String? = nil, sortBy: String?  = nil) -> Observable<NewsEntity> {
        let request = provider.rx.request(.search(query: query, filter: filter, from: from, to: to, sortBy: sortBy)).map(NewsEntity.self)
        return request.asObservable()
    }

}
