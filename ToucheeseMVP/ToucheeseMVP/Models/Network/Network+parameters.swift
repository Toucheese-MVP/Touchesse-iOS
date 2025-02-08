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
        case .deviceTokenRegistrationRequest(let deviceTokenRegistrationRequest, _):
            var params: Parameters = [:]
            
            params["memberId"] = deviceTokenRegistrationRequest.memberId
            params["deviceToken"] = deviceTokenRegistrationRequest.deviceToken
            
            return params

        // MARK: - SERVER Migration WORK
        case .studioConceptType, .studioDetailType, .studioCalendarType, .productDetailType, .getReservationType:
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
            
        case .appleLoginType(let appleLoginRequest):
            var params: Parameters = [:]
            
            params["idToken"] = appleLoginRequest.idToken
            params["platform"] = appleLoginRequest.platform
            params["deviceId"] = appleLoginRequest.deviceId
            
            return params
            
        case .reissueToken(let reissueTokenRequest):
            var params: Parameters = [:]
            
            params["refreshToken"] = reissueTokenRequest.refreshToken
            params["deviceId"] = reissueTokenRequest.deviceId
            
            return params
            
        case .reservationInstantType(let request):
            var params: Parameters = [:]
            
            params["productId"] = request.productId
            params["studioId"] = request.studioId
            params["memberId"] = request.memberId
            params["phone"] = request.phone
            params["totalPrice"] = request.totalPrice
            params["createDate"] = request.createDate
            params["createTime"] = request.createTime
            params["personnel"] = request.personnel
            params["addOptions"] = request.addOptions
            
            print("\(params)")
            
            return params
        }
    }
}

