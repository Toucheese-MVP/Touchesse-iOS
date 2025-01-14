//
//  Network+baseURL.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/14/24.
//

import Foundation
import Alamofire

extension Network {
    func getMethod() -> HTTPMethod {
        switch self {
        case .studioListRequest, .studioDetailRequest, .studioRequest, .reviewListRequest, .reviewDetailRequest, .productDetailRequest, .reservationListRequest, .reservationDetailRequest, .reservableTimeRequest, .studioLikeListRequest:
            return .get
        case .studioReservationRequest, .deviceTokenRegistrationRequest, .sendSocialIDRequest, .refreshAccessTokenRequest, .appOpenRequest, .logoutRequest, .studioLikeRequest:
            return .post
        case .reservationCancelRequest, .withdrawalRequest, .studioLikeCancelRequest:
            return .delete
        case .nicknameChangeRequest:
            return .put
        // MARK: - SERVER Migration WORK
        case .studioConceptType, .conceptedStudioListType:
            return . get
        }
    }
}
