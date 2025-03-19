//
//  FCMAPI.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 3/19/25.
//

import Foundation
import Alamofire

enum FCMAPI {
    case postFCM(String)
}

extension FCMAPI: TargetType {
    
    static var apiType: APIType = .fcm
    
    var baseURL: String {
        Self.apiType.baseURL
    }
    
    var path: String {
        switch self {
        case .postFCM:
            return ""
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .postFCM(let string):
            return .post
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        switch self {
        case .postFCM:
            return HeaderType.jsonWithAccessToken.value
        }
    }
    
    var encoding: any Alamofire.ParameterEncoding {
        switch self {
        case .postFCM(let string):
            EncodingType.post.value
        }
    }
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case .postFCM(let token):
            return ["fcmToken": token]
        }
    }
    
    
}
