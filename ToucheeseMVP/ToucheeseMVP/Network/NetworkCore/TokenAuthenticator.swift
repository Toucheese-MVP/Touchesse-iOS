//
//  TempAuthInterceptor.swift
//  ToucheeseMVP
//
//  Created by 강건 on 4/16/25.
//

import Foundation
import Alamofire

struct TokenAuthCredential: AuthenticationCredential {
    let accessToken: String
    let refreshToken: String
    
    /// 토큰 갱신이 필요한지에 대한 값
    var requiresRefresh: Bool
}

final class TokenAuthenticator: Authenticator {
    typealias Credential = TokenAuthCredential
    
    
    // (1 ~ 4) 네트워크 오류 시 실행
    // (4)
    func apply(_ credential: Credential, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
    }
    
    // (3)
    func refresh(_ credential: TokenAuthCredential, for session: Alamofire.Session, completion: @escaping @Sendable (Result<TokenAuthCredential, any Error>) -> Void) {
        Task {
            await AuthenticationManager.shared
                .reissueToken()
            
            guard let accessToken = AuthenticationManager.shared.accessToken,
                  let refreshToken = AuthenticationManager.shared.refreshToken else {
                
                completion(.failure(NetworkError.unauthorized))
                return
            }
            
            let newCredential = Credential(
                accessToken: accessToken,
                refreshToken: refreshToken,
                requiresRefresh: false
            )
            
            completion(.success(newCredential))
        }
    }
    
    // (1)
    func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: any Error) -> Bool {
        return response.statusCode == 401
    }
    
    // (2)
    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: TokenAuthCredential) -> Bool {
        let bearerToken = HTTPHeader.authorization(bearerToken: credential.accessToken).value
        return urlRequest.headers["Authorization"] == bearerToken
    }
}
