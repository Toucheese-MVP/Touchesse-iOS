//
//  Network+baseURL.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/14/24.
//

import Foundation

extension Network {
    func getPath() -> String {
        switch self {
        case .studioListRequest(
            let concept,
            let isHighRating,
            let regionArray,
            let price,
            _
        ):
            // 컨셉 경로 추가
            var path = "/concept/\(concept.rawValue)"
            
            // 점수 경로 추가
            if let isHighRating, isHighRating {
                path += "/high-rating"
            }
            
            // 지역 경로 추가
            if let regionArray, !regionArray.isEmpty {
                path += "/regions"
            }
            
            // 가격 경로 추가
            if let price {
                switch price {
                case .all:
                    break
                case .lessThan100_000won, .lessThan200_000won, .moreThan200_000won:
                    path += "/low-pricing"
                }
            }
            
            return path
        case .studioDetailRequest(let id):
            return "/detail/\(id)"
        case .studioRequest(let id):
            return "/\(id)"
            
        case .reviewListRequest(let studioID, let productID, _):
            var path = "/\(studioID)"
            
            if let productID { path += "/product/\(productID)" }
            
            return path
        case .reviewDetailRequest(let studioID, let reviewID):
            return "/\(studioID)/detail/\(reviewID)"
            
        case .productDetailRequest(let id):
            return "/\(id)"
        case .studioReservationRequest, .deviceTokenRegistrationRequest, .studioLikeRequest, .studioLikeListRequest:
            return ""
        case .reservationListRequest(_, let memberID, let isPast):
            var path = "/member/\(memberID)"
            
            if isPast {
                path += "/completed-cancelled"
            }
            
            return path
        case .reservationDetailRequest(let id):
            return "/\(id)"
        case .reservationCancelRequest(let reservationID, _, _):
            return "/\(reservationID)/cancel"
        case .reservableTimeRequest(studioId: let studioId, _):
            return "/\(studioId)/available-slots?"
        case .sendSocialIDRequest:
            return "/login"
        case .refreshAccessTokenRequest:
            return "/refreshAccessToken"
        case .appOpenRequest:
            return "/appOpen"
        case .logoutRequest:
            return "/logout"
        case .withdrawalRequest:
            return "/withdrawal"
        case .nicknameChangeRequest(let nicknameChangeRequest):
            return "/\(nicknameChangeRequest.memberId)/name"
        case .studioLikeCancelRequest(let studioLikeRelationRequest):
            return "/delete/\(studioLikeRelationRequest.studioId)"
            
        // MARK: - SERVER Migration WORK
        case .studioConceptType, .kakaoLoginType, .reissueToken:
            return ""
        case .conceptedStudioListType(let conceptedStudioRequest):
            if conceptedStudioRequest.location == [] && conceptedStudioRequest.price == nil && conceptedStudioRequest.rating == nil {
                return "/\(conceptedStudioRequest.studioConceptId)/studios?"
            } else {
                return "/\(conceptedStudioRequest.studioConceptId)/studios/filters?"
            }
        case .studioCalendarType(let studioID, _):
            return "/\(studioID)/calendars"
        case .studioDetailType(let studioID):
            return "/\(studioID)"
        case .productDetailType(let productId):
            return "/\(productId)"
        case .reservationInstantType:
            return "/instant"
        }
    }
}
