//
//  Network+baseURL.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/14/24.
//

import Foundation

extension Network {
    func getBaseURL() -> String {
        let server_url = Bundle.main.serverURL
        
        switch self {
        case .studioListRequest, .studioDetailRequest, .studioRequest:
            return "\(server_url)/api/v1/studio"
        case .reviewListRequest, .reviewDetailRequest:
            return "\(server_url)/api/v1/review/studio"
        case .productDetailRequest:
            return "\(server_url)/api/v1/product"
        case .studioReservationRequest, .reservationDetailRequest, .reservationListRequest, .reservationCancelRequest, .reservableTimeRequest:
            return "\(server_url)/api/v1/reservation"
        case .deviceTokenRegistrationRequest:
            return "\(server_url)/api/v1/device/register"
        case .sendSocialIDRequest, .refreshAccessTokenRequest, .appOpenRequest, .logoutRequest, .withdrawalRequest, .nicknameChangeRequest:
            return "\(server_url)/api/v1/auth"
        case .studioLikeRequest, .studioLikeCancelRequest, .studioLikeListRequest:
            return "\(server_url)/api/v1/like"
            
        // MARK: - SERVER Migration WORK
        case .studioConceptReqeust:
            return "\(server_url)/v1"
        }
    }
}
