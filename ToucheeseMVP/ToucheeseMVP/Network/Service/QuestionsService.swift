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
}
