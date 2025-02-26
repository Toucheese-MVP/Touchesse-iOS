//
//  ReservationAPI.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/19/25.
//

import Foundation
import Alamofire

enum MemberAPI {
    /// 즉시 예약
    case reservationInstant(ReservationInstantRequest)
    /// 예약 내역 불러오기
    case getReservation(Int)
    case cleanup
    /// 예약 취소
    case cancelReservation(CancelReservationRequest)
}

extension MemberAPI: TargetType {
    
    static var apiType: APIType = .member
    
    var baseURL: String {
        Self.apiType.baseURL
    }
    
    var path: String {
        switch self {
        case .reservationInstant:
            return "/reservations/instant"
        case .getReservation(let page):
            return "/reservations?page=\(page)"
        case .cleanup:
            return "/cleanup"
        case .cancelReservation(let request):
            return "/reservations/\(request.reservationID)"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .reservationInstant:
            return .post
        case .getReservation:
            return .get
        case .cleanup:
            return .delete
        case .cancelReservation:
            return .put
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        switch self {
        case .reservationInstant, .getReservation, .cleanup, .cancelReservation:
            HeaderType.jsonWithAccessToken.value
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .reservationInstant:
            EncodingType.post.value
        case .getReservation:
            EncodingType.get.value
        case .cleanup:
            EncodingType.delete.value
        case .cancelReservation:
            EncodingType.put.value
        }
    }
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case .reservationInstant(let request):
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
        case .getReservation, .cleanup:
            return [:]
        case .cancelReservation(let request):
            var params: Parameters = [:]
            params["createDate"] = request.createDate
            params["createTime"] = request.createTime
            params["status"] = request.status
            return params
        }
    }
    
}
