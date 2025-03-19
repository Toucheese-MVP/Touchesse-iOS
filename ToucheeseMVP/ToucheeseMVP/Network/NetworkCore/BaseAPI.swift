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
    var imageRequest: RequestWithImageProtocol? { get }
}

extension TargetType {
    var imageRequest: RequestWithImageProtocol? { nil }
}

enum APIType {
    case auth
    case token
    case concept
    case studio
    case product
    case member
    case fcm
    case questions
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
        case .member:
            return "\(server_url)/v1/members"
        case .fcm:
            return "\(server_url)/v1/fcm"
        case .questions:
            return "\(server_url)/v1/questions"
        }
    }
}

enum HeaderType {
    case json
    case jsonWithAccessToken
    case multipartForm
    
    public var value: HTTPHeaders {
        switch self {
        case .json:
            return ["Content-Type": "application/json"]
        case .jsonWithAccessToken:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(AuthenticationManager.shared.accessToken ?? "none")"]
        case .multipartForm:
            return [
                "Authorization": "Bearer \(AuthenticationManager.shared.accessToken ?? "none")",
                "Content-Type": "multipart/form-data"
            ]
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
