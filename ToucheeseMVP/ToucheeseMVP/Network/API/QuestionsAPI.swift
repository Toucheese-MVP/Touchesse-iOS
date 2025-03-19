//
//  QuestionsAPI.swift
//  ToucheeseMVP
//
//  Created by 강건 on 3/14/25.
//

import Foundation
import Alamofire

enum QuestionsAPI {
    /// 문의하기 글 생성
    case postQuestion(QuestionRequest)
    case fetchQuestions(page: Int)
}

extension QuestionsAPI: TargetType {
    static var apiType: APIType = .questions

    var baseURL: String {
        Self.apiType.baseURL
    }
    
    var path: String {
        switch self {
        case .postQuestion:
            return ""
        case .fetchQuestions:
            return ""
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .postQuestion:
            return .post
        case .fetchQuestions:
            return .get
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        switch self {
        case .postQuestion:
            return HeaderType.multipartForm.value
        case .fetchQuestions:
            return HeaderType.jsonWithAccessToken.value
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .postQuestion:
            EncodingType.post.value
        case .fetchQuestions:
            EncodingType.get.value
        }
    }
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case .postQuestion(let request):
            var params: Parameters = [:]
            
            params["title"] = request.title
            params["content"] = request.content
            
            return params
        case .fetchQuestions(page: let page):
            var params: Parameters = [:]
            
            params["page"] = page
            
            return params
        }
    }
    
    var imageRequest: RequestWithImageProtocol? {
        switch self {
        case .postQuestion(let request):
            return request
        case .fetchQuestions:
            return nil
        }
    }
}
