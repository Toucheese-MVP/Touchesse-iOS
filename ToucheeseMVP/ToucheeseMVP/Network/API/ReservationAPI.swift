//
//  ReservationAPI.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/19/25.
//

import Foundation
import Alamofire

enum ReservationAPI {
    /// 즉시 예약
    case reservationInstant(ReservationInstantRequest)
    /// 예약 내역 불러오기
    case getReservation(Int)
}

extension ReservationAPI: TargetType {
    
    static var apiType: APIType = .reservation
    
    var baseURL: String {
        Self.apiType.baseURL
    }
    
    var path: String {
        switch self {
        case .reservationInstant:
            return "/instant"
        case .getReservation(let page):
            return "?page=\(page)"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .reservationInstant:
            return .post
        case .getReservation:
            return .get
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        switch self {
        case .reservationInstant, .getReservation:
            HeaderType.jsonWithAccessToken.value
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .reservationInstant:
            EncodingType.post.value
        case .getReservation:
            EncodingType.get.value
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
        case .getReservation:
            return [:]
        }
    }
    
}
