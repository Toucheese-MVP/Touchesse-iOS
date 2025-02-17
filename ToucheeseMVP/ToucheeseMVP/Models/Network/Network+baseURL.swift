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
        case .deviceTokenRegistrationRequest:
            return "\(server_url)/api/v1/device/register"
            
        // MARK: - SERVER Migration WORK
        case .studioConceptType, .conceptedStudioListType:
            return "\(server_url)/v1/concepts"
        case .studioCalendarType, .studioDetailType:
            return "\(server_url)/v1/studios"
        case .productDetailType:
            return "\(server_url)/v1/products"
        case .reservationInstantType, .getReservationType:
            return "\(server_url)/v1/members/reservations"
        case .kakaoLoginType:
            return "\(server_url)/v1/auth/kakao"
        case .appleLoginType:
            return "\(server_url)/v1/auth/apple"
        case .reissueToken:
            return "\(server_url)/v1/tokens/reissue"
        case .logoutType:
            return "\(server_url)/v1/tokens/logout?"
        case .appleWithdrawType:
            return "\(server_url)/v1/auth/apple/withdraw"
        case .kakaoWithdrawType:
            return "\(server_url)/v1/auth/kakao/withdraw"
        }
    }
}
