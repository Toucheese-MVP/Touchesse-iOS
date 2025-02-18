//
//  Network+baseURL.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/14/24.
//

import Foundation
import Alamofire

extension Network {
    func getEncoding() -> ParameterEncoding {
        switch self {
        case .deviceTokenRegistrationRequest:
            return JSONEncoding.default
            
        // MARK: - SERVER Migration WORK
        case .studioConceptType, .conceptedStudioListType, .studioCalendarType, .studioDetailType, .productDetailType, .getReservationType:
            return URLEncoding.default
        case .kakaoLoginType, .appleLoginType, .reissueToken, .reservationInstantType:
            return JSONEncoding.default
        }
    }
}
