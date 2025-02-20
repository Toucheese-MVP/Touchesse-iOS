//
//  AuthInterceptor.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/18/25.
//

import Foundation
import Alamofire

final class AuthInterceptor: RequestInterceptor {
    /// 네트워크 요청이 전송되기 전에 설정을 적용하는 메서드
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var adaptedRequest = urlRequest
        
        if let accessToken = AuthenticationManager.shared.accessToken {
            adaptedRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        completion(.success(adaptedRequest))
    }
    
    /// 특정한 경우 네트워크 재요청을 보내는 메서드
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) async {
        // 401 에러가 아닌 경우 재전송 없이 에러 리턴
        guard let response = request.response, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }

        // 헤더의 에러코드가 4005가 아닌 경우 리턴
        guard let errorCode = response.allHeaderFields["x-error-code"] as? Int, errorCode == 4001 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        // 토큰 갱신
        await AuthenticationManager.shared.reissueToken()
        
        completion(.retry)
    }
}
