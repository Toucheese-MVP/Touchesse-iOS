//
//  QuestionDetailViewModel.swift
//  ToucheeseMVP
//
//  Created by 강건 on 3/25/25.
//

import Foundation

protocol QuestionDetailViewModelProtocol: ObservableObject {
    /// 문의 내역
    var question: Question { get }
    /// 문의 답변
    var questionResponse: QuestionResponse? { get }
    
    /// 답변 fetch하기
    func fetchAnswer() async
}

final class QuestionDetailViewModel: QuestionDetailViewModelProtocol {
    private let questionService = DefaultQuestionsService(session: SessionManager.shared.authSession)
    let question: Question
    private(set) var questionResponse: QuestionResponse?
    
    init(question: Question) {
        self.question = question
        
        Task {
            await fetchAnswer()
        }
    }
    
    func fetchAnswer() async {
        // 답변 완료인 상태에만 fetch
        if question.questionStaus == .complete {
            do {
                let result = try await questionService.fetchQuestionResponse(questionId: question.id)
                
                await MainActor.run {
                    questionResponse = result.questionResponse
                }
            } catch {
                print("문의 답변 불러오기 에러: \(error.localizedDescription)")
            }
        }
    }
}
