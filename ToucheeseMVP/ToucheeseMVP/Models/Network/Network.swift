//
//  Network.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/13/24.
//

import Foundation
import Alamofire

enum Network {        
    /// Push Notification
    case deviceTokenRegistrationRequest(DeviceTokenRegistrationRequest, accessToken: String)
    
    // MARK: - SERVER Migration WORK
    // 컨셉 조회
    case studioConceptType
    case conceptedStudioListType(ConceptedStudioRequest)
    case studioDetailType(studioID: Int)
    case studioCalendarType(studioID: Int, yearMonth: String?)
    
    /// 상품 상세 조회
    case productDetailType(productId: Int)
    
    /// 예약
    case reservationInstantType(ReservationInstantRequest)
    case getReservationType(Int)
    
    
    // 소셜 로그인
    case kakaoLoginType(KakaoLoginRequest)
    case appleLoginType(AppleLoginRequest)
    
    // 소셜 로그아웃
    case logoutType(deviceId: String)
    
    // 회원 탈퇴
    case appleWithdrawType(authorizationCode: String)
    case kakaoWithdrawType(code: String)
    
    // 토큰 재발급
    case reissueToken(ReissueTokenRequest)
}
