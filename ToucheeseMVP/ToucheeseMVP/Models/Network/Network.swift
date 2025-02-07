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
    
    // 상품 상세 조회
    case productDetailType(productId: Int)
    
    // 즉시 예약
    case reservationInstantType(ReservationInstantRequest)
    
    /// 카카오 로그인
    case kakaoLoginType(KakaoLoginRequest)
    case appleLoginType(AppleLoginRequest)
    case reissueToken(ReissueTokenRequest)
}
