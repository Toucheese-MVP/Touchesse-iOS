//
//  QuestionCreateViewModel.swift
//  ToucheeseMVP
//
//  Created by 강건 on 3/26/25.
//

import Foundation
import SwiftUI
import PhotosUI

protocol QuestionCreateViewModelProtocol: ObservableObject {
    /// 문의 제목
    var questionTitle: String { get set }
    /// 문의 내용
    var questionContent: String { get set }
    /// 문의를 보내는 중인지 상태 값
    var isPostingQuestion: Bool { get }
    
    /// 문의하기 요청
    func postQuestion(_ imageDatas: [Data]) async

}

final class QuestionCreateViewModel: QuestionCreateViewModelProtocol {
    private let questionService = DefaultQuestionsService(session: SessionManager.shared.authSession)

    @Published var questionTitle: String = ""
    @Published var questionContent: String = ""
    @Published private(set) var isPostingQuestion: Bool = false
    
    /// 문의하기 요청
    func postQuestion(_ imageDatas: [Data]) async {
        await MainActor.run {
            isPostingQuestion = true
        }
        
        do {
            // 서버에 예약 전송
            try await questionService.postQuestions(QuestionRequest(title: questionTitle,
                                                                    content: questionContent,
                                                                    imageArray: imageDatas))
        
            // NotificationCenter에 예약 내역 초기화 요청
            NotificationManager.shared.postRefreshQuestion()
        } catch {
            print("문의하기 요청 에러: \(error.localizedDescription)")
        }
    }
}
