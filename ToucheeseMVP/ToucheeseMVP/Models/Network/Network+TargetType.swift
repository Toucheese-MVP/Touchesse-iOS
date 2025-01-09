//
//  Network+TargetType.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/14/24.
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

extension Network: TargetType {
    var baseURL: String {
        getBaseURL()
    }
    
    var path: String {
        getPath()
    }
    
    var method: Alamofire.HTTPMethod {
        getMethod()
    }
    
    var headers: Alamofire.HTTPHeaders? {
        getHeaders()
    }
    
    var encoding: ParameterEncoding {
        getEncoding()
    }
    
    var parameters: Alamofire.Parameters? {
        getParameters()
    }
}
