//
//  Network.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/13/24.
//

import Foundation
import Alamofire

enum Network {
    /// Studio
    case studioListRequest(
        concept: StudioConcept,
        isHighRating: Bool?,
        regionArray: [StudioRegion]?,
        price: StudioPrice?,
        page: Int?
    )
    case studioDetailRequest(id: Int)
    case studioRequest(id: Int)
    
    /// Review
    case reviewListRequest(
        studioID: Int,
        productID: Int?,
        page: Int?
    )
    case reviewDetailRequest(
        studioID: Int,
        reviewID: Int
    )
    
    /// Product
    case productDetailRequest(id: Int)
    
    /// Reservation
    case studioReservationRequest(ReservationRequest, accessToken: String)
    case reservationListRequest(accessToken: String, memberID: Int, isPast: Bool)
    case reservationDetailRequest(id: Int)
    case reservationCancelRequest(reservationID: Int, memberID: Int, accessToken: String)
    case reservableTimeRequest(studioId: Int, date: Date)
    
    /// Push Notification
    case deviceTokenRegistrationRequest(DeviceTokenRegistrationRequest, accessToken: String)
    
    /// Login Logics
    case sendSocialIDRequest(socialID: String, socialType: SocialType)
    case refreshAccessTokenRequest(RefreshAccessTokenRequest)
    case appOpenRequest(AppOpenRequest)
    case logoutRequest(accessToken: String)
    case withdrawalRequest(accessToken: String)
    
    /// Member
    case nicknameChangeRequest(NicknameChangeRequest)
    case studioLikeRequest(StudioLikeRelationRequest)
    case studioLikeCancelRequest(StudioLikeRelationRequest)
    case studioLikeListRequest(accsessToken: String, memberID: Int)
    
    // MARK: - SERVER Migration WORK
    // 컨셉 조회
    case studioConceptType
    case conceptedStudioListType(ConceptedStudioRequest)
    case studioDetailType(studioID: Int)
    case studioCalendarType(studioID: Int, yearMonth: String?)
    
    // 상품 상세 조회
    case productDetailType(productId: Int)
    
    /// 카카오 로그인
    case kakaoLoginType(KakaoLoginRequest)
    case reissueToken(ReissueTokenRequest)
}
