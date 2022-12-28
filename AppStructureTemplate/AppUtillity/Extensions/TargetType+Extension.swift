//
//  TargetType+Extension.swift
//  MediaParkAssignment
//
//  Created by Kan Chanproseth on 06/03/2022.
//

import Foundation
import Moya
extension TargetType{
    
    //BaseURL
    public var baseURL: URL {
        return URL(string: "https://gnews.io/api/v4")!
    }
    
    var sampleData: Data { return Data() }
    
    var defaulParameters: [String: Any]? {
        return nil
    }
    
    public var headers: [String : String]? {
        let assigned: [String: String] = ["Content-Type": "application/json"]
        return assigned
    }
}
