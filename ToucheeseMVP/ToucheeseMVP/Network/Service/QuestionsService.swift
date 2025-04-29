//
//  QuestionsService.swift
//  ToucheeseMVP
//
//  Created by 강건 on 3/14/25.
//

import Foundation
import Alamofire

protocol QuestionsService {
    /// 문의하기 등록
    func postQuestions(_ questionReqeust: QuestionRequest) async throws
    /// 문의목록 불러오기
    func fetchQuestions(page: Int) async throws -> QuestionEntity
    /// 문의 답변 불러오기
    func fetchQuestionResponse(questionId: Int) async throws -> QuestionResponseEntity
}

final class DefaultQuestionsService: BaseService { }

extension DefaultQuestionsService: QuestionsService {
    func postQuestions(_ questionReqeust: QuestionRequest) async throws {
        let request = QuestionsAPI.postQuestion(questionReqeust)
        _ = try await performRequest(request, decodingType: String.self)
    }
    
    func fetchQuestions(page: Int) async throws -> QuestionEntity {
        let request = QuestionsAPI.fetchQuestions(page: page)
        let result = try await performRequest(request, decodingType: QuestionEntity.self)
        return result
    }
    
    func fetchQuestionResponse(questionId: Int) async throws -> QuestionResponseEntity {
        let request = QuestionsAPI.fetchQuestionResponse(questionId: questionId)
        let result = try await performRequest(request, decodingType: QuestionResponseEntity.self)
        return result
    }
}

final class MockQuestionService: QuestionsService {
    func postQuestions(_ questionReqeust: QuestionRequest) async throws {
        
    }
    
    func fetchQuestions(page: Int) async throws -> QuestionEntity {
        return .init(totalPages: 0, totalElements: 0, size: 0, content: [], number: 0, numberOfElements: 0, pageable: .init(pageNumber: 0, pageSize: 0, offset: 0, paged: true, unpaged: false), last: true, first: false, empty: false)
    }
    
    func fetchQuestionResponse(questionId: Int) async throws -> QuestionResponseEntity {
        return .init(questionResponse: .init(id: 0, title: "mockTitle", content: "mockContent", createDate: ""))
    }
    
    
}
