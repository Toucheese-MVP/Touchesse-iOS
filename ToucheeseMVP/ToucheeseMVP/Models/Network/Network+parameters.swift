//
//  Network+baseURL.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/14/24.
//

import Foundation
import Alamofire

extension Network {
    func getParameters() -> Parameters? {
        switch self {
        case .studioListRequest(
            _,
            _,
            let regionArray,
            let price,
            let page
        ):
            var params: Parameters = [:]
            
            if let regionArray {
                params["regionIds"] = regionArray.map { $0.rawValue }
            }
            
            if let price {
                switch price {
                case .all:
                    break
                case .lessThan100_000won:
                    params["priceCategory"] = "LOW"
                case .lessThan200_000won:
                    params["priceCategory"] = "MEDIUM"
                case .moreThan200_000won:
                    params["priceCategory"] = "HIGH"
                }
            }
            
            if let page = page {
                params["page"] = page
            }
            
            return params
        case .reviewListRequest(_, _, let page):
            var params: Parameters = [:]
            
            if let page { params["page"] = page }
            
            return params
        case .studioDetailRequest, .studioRequest, .reviewDetailRequest, .productDetailRequest, .reservationListRequest, .reservationDetailRequest, .logoutRequest, .withdrawalRequest:
            return [:]
        case .studioReservationRequest(let reservationRequestType, _):
            var params: Parameters = [:]
            
            params["memberId"] = reservationRequestType.memberId
            params["studioId"] = reservationRequestType.studioId
            params["reservationDate"] = reservationRequestType.reservationDateString
            params["reservationTime"] = reservationRequestType.reservationTimeString
            params["productId"] = reservationRequestType.productId
            params["productOption"] = reservationRequestType.productOptionString
            params["totalPrice"] = reservationRequestType.totalPrice
            params["phoneNumber"] = reservationRequestType.phoneNumberString
            params["email"] = reservationRequestType.email
            params["addPeopleCnt"] = reservationRequestType.addPeopleCnt
            
            return params
        case .reservationCancelRequest(_, let memberID, _):
            return ["memberId": memberID]
        case .deviceTokenRegistrationRequest(let deviceTokenRegistrationRequest, _):
            var params: Parameters = [:]
            
            params["memberId"] = deviceTokenRegistrationRequest.memberId
            params["deviceToken"] = deviceTokenRegistrationRequest.deviceToken
            
            return params
        case .reservableTimeRequest(_:_, date: let date):
            var params: Parameters = [:]
            
            params["date"] = date.toString(format: .requestYearMonthDay)
            
            return params
        case .sendSocialIDRequest(_:_, socialType: let socialType):
            var params: Parameters = [:]
            
            params["socialType"] = socialType.rawValue
            
            return params
        case .refreshAccessTokenRequest(let refreshAccessTokenRequest):
            var params: Parameters = [:]
            
            params["accessToken"] = refreshAccessTokenRequest.accessToken
            params["refreshToken"] = refreshAccessTokenRequest.refreshToken
            
            return params
        case .appOpenRequest(let appOpenRequest):
            var params: Parameters = [:]
            
            params["accessToken"] = appOpenRequest.accessToken
            params["refreshToken"] = appOpenRequest.refreshToken
            
            return params
        case .nicknameChangeRequest(let nicknameChangeRequest):
            var params: Parameters = [:]
            
            params["newName"] = nicknameChangeRequest.newName
            
            return params
        case .studioLikeRequest(let studioLikeRelationRequest):
            var params: Parameters = [:]
            
            params["memberId"] = studioLikeRelationRequest.memberId
            params["studioId"] = studioLikeRelationRequest.studioId
            
            return params
        case .studioLikeCancelRequest(let studioLikeRelationRequest):
            var params: Parameters = [:]
            
            params["memberId"] = studioLikeRelationRequest.memberId
            
            return params
        case .studioLikeListRequest(_, let memberId):
            var params: Parameters = [:]
            
            params["memberId"] = memberId
            
            return params
            
        // MARK: - SERVER Migration WORK
        case .studioConceptType, .studioDetailType, .studioCalendarType, .productDetailType:
            return [:]
        case .conceptedStudioListType(let conceptedStudioRequest):
            var params: Parameters = [:]
            
            params["page"] = conceptedStudioRequest.page
            
            if let price = conceptedStudioRequest.price {
                params["price"] = price
            }
            
            if let rating = conceptedStudioRequest.rating {
                params["rating"] = rating
            }
            
            if let location = conceptedStudioRequest.location {
                params["locations"] = location
            }
            
            return params
            
        case .kakaoLoginType(let kakaoLoginRequest):
            var params: Parameters = [:]
            
            params["idToken"] = kakaoLoginRequest.idToken
            params["accessToken"] = kakaoLoginRequest.accessToken
            params["platform"] = kakaoLoginRequest.platform
            params["deviceId"] = kakaoLoginRequest.deviceId
            
            return params
            
        case .reissueToken(let reissueTokenRequest):
            var params: Parameters = [:]
            
            params["refreshToken"] = reissueTokenRequest.refreshToken
            params["deviceId"] = reissueTokenRequest.deviceId
            
            return params
        }
    }
}
