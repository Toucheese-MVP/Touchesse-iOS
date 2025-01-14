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
        case .studioListRequest, .studioDetailRequest, .studioRequest, .reviewListRequest, .reviewDetailRequest, .productDetailRequest, .reservationDetailRequest, .reservableTimeRequest, .refreshAccessTokenRequest:
            return ["Content-Type": "application/json"]
        case .sendSocialIDRequest(socialID: let socialID, _:_):
            var headers: HTTPHeaders = ["Content-Type": "application/json"]
            
            headers["socialId"] = socialID
            
            return headers
        case .reservationListRequest(let accessToken, _, _):
            var headers: HTTPHeaders = ["Content-Type": "application/json"]
            
            headers["Authorization"] = "Bearer \(accessToken)"
            
            return headers
        case .appOpenRequest(let appOpenRequest):
            var headers: HTTPHeaders = ["Content-Type": "application/json"]
            
            headers["Authorization"] = "Bearer \(appOpenRequest.accessToken)"
            
            return headers
        case .deviceTokenRegistrationRequest(_, let accessToken), .studioReservationRequest(_, let accessToken):
            var headers: HTTPHeaders = ["Content-Type": "application/json"]
            
            headers["Authorization"] = "Bearer \(accessToken)"
            
            return headers
        case .reservationCancelRequest(_, _, let accessToken):
            var headers: HTTPHeaders = ["Content-Type": "application/json"]
            
            headers["Authorization"] = "Bearer \(accessToken)"
            
            return headers
        case .logoutRequest(let accessToken), .withdrawalRequest(let accessToken):
            var headers: HTTPHeaders = ["Content-Type": "application/json"]
            
            headers["Authorization"] = "Bearer \(accessToken)"
            
            return headers
        case .nicknameChangeRequest(let nicknameChangeRequest):
            var headers: HTTPHeaders = ["accept": "application/json"]
            
            headers["Authorization"] = "Bearer \(nicknameChangeRequest.accessToken)"
            
            return headers
        case .studioLikeRequest(let studioLikeRelationRequest), .studioLikeCancelRequest(let studioLikeRelationRequest):
            var headers: HTTPHeaders = ["Content-Type": "application/json"]
            
            headers["Authorization"] = "Bearer \(studioLikeRelationRequest.accessToken)"
            
            return headers
        case .studioLikeListRequest(let accessToken, _):
            var headers: HTTPHeaders = ["Content-Type": "application/json"]
            
            headers["Authorization"] = "Bearer \(accessToken)"
            
            return headers
        // MARK: - SERVER Migration WORK
        case .studioConceptType, .conceptedStudioListType:
            var headers: HTTPHeaders = ["accept": "*/*"]
            
            return headers
        }
    }
}
