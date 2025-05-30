//
//  StudioAPI.swift
//  ToucheeseMVP
//
//  Created by 강건 on 2/19/25.
//

import Foundation
import Alamofire

enum StudioAPI {
    /// 스튜디오 예약에 필요한 캘린더 데이터 요청
    case studioCalendar(studioID: Int, yearMonth: String?)
    /// 스튜디오 상세 데이터 요청
    case studioDetail(studioID: Int)
    /// 스튜디오 리뷰 목록 조회
    case studioReviewList(studioID: Int)
    /// 해당 리뷰 상세 조회
    case reviewDetail(studioID: Int, reviewID: Int)
    /// 리뷰 작성
    case postReview(ReviewRequest)
}

extension StudioAPI: TargetType {
    
    static var apiType: APIType = .studio
    
    var baseURL: String {
        Self.apiType.baseURL
    }
    
    var path: String {
        switch self {
        case .studioCalendar(let studioId, _):
            return "/\(studioId)/calendars"
        case .studioDetail(let studioId):
            return "/\(studioId)"
        case .studioReviewList(let studioId):
            return "/\(studioId)/reviews"
        case let .reviewDetail(studioId, reviewId):
            return "/\(studioId)/reviews/\(reviewId)"
        case .postReview(let request):
            return "/\(request.studioID)/products/\(request.productID)/reviews"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .studioCalendar, .studioDetail, .studioReviewList, .reviewDetail:
            return .get
        case .postReview:
            return .post
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        switch self {
        case .postReview:
            HeaderType.multipartForm.value
        default:
            HeaderType.json.value
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .studioCalendar, .studioDetail, .studioReviewList, .reviewDetail:
            EncodingType.get.value
        case .postReview:
            EncodingType.post.value
        }
    }
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case .studioCalendar(_, let yearMonth):
            var params: Parameters = [:]
            
            params["yearMonth"] = yearMonth
            
            return params
        case .postReview(let request):
            var params: Parameters = [:]
            
            params["content"] = request.content
            params["rating"] = request.rating
            
            return params
        case .studioDetail, .studioReviewList, .reviewDetail:
            return [:]
        }
    }
    
    var imageRequest: RequestWithImageProtocol? {
        switch self {
        case .postReview(let request):
            request
        default:
            nil
        }
    }
}
