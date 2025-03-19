//
//  FCMService.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 3/19/25.
//

import Foundation

protocol FCMService {
    func postFCMToken(token: String) async throws
}

final class DefaultFCMService: BaseService { }

extension DefaultFCMService: FCMService {
    
    func postFCMToken(token: String) async throws {
        let request = FCMAPI.postFCM(token)
        _ = try await performRequest(request, decodingType: FCMEntity.self)
    }
    
}
