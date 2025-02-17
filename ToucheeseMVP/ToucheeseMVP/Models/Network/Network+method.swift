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
        case .deviceTokenRegistrationRequest:
            return .post

        // MARK: - SERVER Migration WORK
        case .studioConceptType, .conceptedStudioListType, .studioCalendarType, .studioDetailType, .productDetailType, .getReservationType:
            return .get
        case .kakaoLoginType, .appleLoginType, .reissueToken, .reservationInstantType:
            return .post
        case .logoutType, .appleWithdrawType, .kakaoWithdrawType:
            return .delete
        }
    }
}
