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
        case .deviceTokenRegistrationRequest:
            return ""
            
        // MARK: - SERVER Migration WORK
        case .studioConceptType, .kakaoLoginType, .appleLoginType, .reissueToken:
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
        case .getReservationType:
            return "?page=0"
        }
    }
}
