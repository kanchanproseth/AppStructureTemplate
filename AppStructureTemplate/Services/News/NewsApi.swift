//
//  NewsApi.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 06/03/2022.
//

import Moya

enum NewsApi {
    static private let apiKey = "938fd55cd171393c5625a6dfd8fc825d"
    
    case topHeadline
    case search(query: String?, filter: String?, from: String?, to: String?, sortBy: String?)
}

extension NewsApi: TargetType {
    
    var path: String {
        switch self {
        case .topHeadline: return "/top-headlines"
        case .search: return "/search"
        }
    }
    
    
    var method: Moya.Method {
        switch self {
        case .topHeadline: return .get
        case .search: return .get
        }
    }
    
    
    
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
            
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        var params = ["token" : NewsApi.apiKey]
        switch self {
        case .topHeadline:
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .search(query: let query, filter: let filter, from: let from, to: let to, sortBy: let sortBy):
            self.setUpParamSearch(params: &params, query: query, filter: filter, from: from, to: to, sortBy: sortBy)
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
}

extension NewsApi {
    func setUpParamSearch(params: inout [String: String],
                          query: String?, filter: String?,
                          from: String?,
                          to: String?,
                          sortBy: String?) {
        if let query = query {
            params["q"] = query
        }
        
        if let filter = filter, !filter.isEmpty {
            params["in"] = filter
        }
        
        if let from = from, !from.isEmpty {
            params["from"] = from
        }
        
        if let to = to, !to.isEmpty {
            params["to"] = to
        }
        
        if let sortBy = sortBy, !sortBy.isEmpty {
            params["sortby"] = sortBy
        }
        
    }
}
