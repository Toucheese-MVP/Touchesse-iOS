//
//  QuestionViewModel.swift
//  ToucheeseMVP
//
//  Created by 강건 on 3/17/25.
//

import Foundation
import Combine

protocol QuestionViewModelProtocol: ObservableObject {
    /// 유저가 문의한 목록
    var questions: [Question] { get }

    /// 문의한 목록 가져오기
    func fetchQuestions() async
    /// 문의하기 목록 Refresh
    func refreshAction() async
}

protocol PrivateQuestionViewModelProtocolLogic {
    /// 문의 내역 초기화 구독
    func subscribeRefreshQuestion()
    func subscribeLogoutEvent()
}

final class QuestionViewModel: QuestionViewModelProtocol, PrivateQuestionViewModelProtocolLogic {
    private let questionService: QuestionsService
    @Published private(set) var questions: [Question] = []
    
    private var cancellables = Set<AnyCancellable>()
    private var page: Int = 0
    private var isLastPage = false
    
    init(questionService: QuestionsService) {
        self.questionService = questionService
        subscribeRefreshQuestion()
        subscribeLogoutEvent()
        
        Task {
            await fetchQuestions()
        }
    }
    
    @MainActor
    func fetchQuestions() async {
        if !isLastPage {
            do {
                let result = try await questionService.fetchQuestions(page: page)
                questions += result.content
                page += 1
                isLastPage = result.last
            } catch {
                print("문의한 목록 불러오기 에러: \(error.localizedDescription)")
            }
        }
    }
    
    @MainActor
    func refreshAction() async {
        resetAction()
        await fetchQuestions()
    }
    
    func subscribeRefreshQuestion() {
        NotificationManager.shared.questionPublisher
            .sink { [weak self] _ in
                Task {
                    await self?.refreshAction()
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func resetAction() {
        page = 0
        questions.removeAll()
        isLastPage = false
    }
    
    func subscribeLogoutEvent() {
        NotificationManager.shared.logoutPublisher
            .sink { [weak self] _ in
                Task {
                    await self?.resetAction()
                    print("문의 내역 초기화")
                }
            }
            .store(in: &cancellables)
    }
}
