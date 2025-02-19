//
//  BaseAPI.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/18/25.
//

import Foundation
import Alamofire

protocol TargetType {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
    var parameters: Parameters? { get }
}

enum APIType {
    case auth
    case token
    case concept
    case studio
    case product
    case reservation
}

extension APIType {
    var baseURL: String {
        let server_url = Bundle.main.serverURL
        
        switch self {
        case .auth:
            return "\(server_url)/v1/auth"
        case .token:
            return "\(server_url)/v1/tokens"
        case .concept:
            return "\(server_url)/v1/concepts"
        case .studio:
            return "\(server_url)/v1/studios"
        case .product:
            return "\(server_url)/v1/products"
        case .reservation:
            return "\(server_url)/v1/members/reservations"
        }
    }
}

enum HeaderType {
    case json
    case jsonWithAccessToken
    
    public var value: HTTPHeaders {
        switch self {
        case .json:
            return ["Content-Type": "application/json"]
        case .jsonWithAccessToken:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(AuthenticationManager.shared.accessToken ?? "none")"]
        }
    }
}

enum EncodingType {
    case get
    case delete
    case post
    case put
    
    public var value: ParameterEncoding {
        switch self {
        case .get, .delete:
            return URLEncoding.default
        case .post, .put:
            return JSONEncoding.default
        }
    }
}
