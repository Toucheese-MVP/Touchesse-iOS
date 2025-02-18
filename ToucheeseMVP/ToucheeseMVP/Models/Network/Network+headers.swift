//
//  Network+baseURL.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/14/24.
//

import Foundation
import Alamofire

extension Network {
    func getHeaders() -> HTTPHeaders? {
        switch self {
        case .deviceTokenRegistrationRequest(_, let accessToken):
            var headers: HTTPHeaders = ["Content-Type": "application/json"]
            
            headers["Authorization"] = "Bearer \(accessToken)"
            
            return headers

        // MARK: - SERVER Migration WORK
        case .studioConceptType, .conceptedStudioListType, .studioCalendarType, .studioDetailType, .productDetailType:
            let headers: HTTPHeaders = ["accept": "*/*"]
            
            return headers
        case .kakaoLoginType, .appleLoginType, .reissueToken:
            let headers: HTTPHeaders = ["Content-Type": "application/json"]
            
            return headers
            
        case .reservationInstantType, .getReservationType:
            var headers: HTTPHeaders = ["Content-Type": "application/json"]
            
            guard let token = AuthenticationManager.shared.accessToken else { return headers }

            headers["Authorization"] =
            "Bearer \(token)"
            
            return headers
        }
    }
}
