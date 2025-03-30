//
//  Question.swift
//  ToucheeseMVP
//
//  Created by 강건 on 3/18/25.
//

import Foundation

struct QuestionEntity: Decodable {
    let totalPages: Int
    let totalElements: Int
    let size: Int
    let content: [Question]
    let number: Int
    //    let sort: StudioPageSort
    let numberOfElements: Int
    let pageable: Pageable
    let last: Bool
    let first: Bool
    let empty: Bool
}

struct Question: Decodable, Hashable {
    let id: Int
    let title: String
    let content: String
    let createDate: String
    let answerStatus: String
    let authorName: String
    let imageUrls: [String]
}

extension Question {
    var questionStaus: QuestionStatus {
        if answerStatus == "답변대기" {
            return .waiting
        } else {
            return .complete
        }
    }
}

extension Question {
    static let sample1: Question = Question(
        id: 1,
        title: "문의하기 예시입니다.",
        content: "사진이랑 생각했던거랑 너무 달라요! 환불 요청합니다아아아 asfk fpeo jfkap ㄹ;ㅐ먀걸 ;ㅐ ㅁㄹ;ㅐㅑ덜 ㅁ;ㅐㅑㄹ ㅓㅣ;먀ㅡ라ㅣ; ㅁㅁ;ㅣ냐 릐;먄드 리; ㅁ냐ㅜㄷ릐;ㅑㅁ ㅜㅡㄴ리;무ㅑㅡ 리;무ㅑ ㅢ;루 ㅣ;만둘. ㅁ;ㅣㅏㅜ ㅣ;ㅁ. ㅜ ㅟㅁ;ㅏㄴ루. 미;ㅏㄹ두. ㅣ;ㅏ물ㄴ ",
        createDate: "2025-03-21",
        answerStatus: "답변대기",
        authorName: "강건",
        imageUrls: [
            "https://i.toucheese-macwin.store/resized/TIt02sE.webp",
            "https://i.toucheese-macwin.store/resized/EKuAbP9.webp"
        ]
    )
    
    static let sample2: Question = Question(
        id: 2,
        title: "문의하기 예시입니다.",
        content: "사진이랑 생각했던거랑 너무 달라요! 환불 요청합니다아아아",
        createDate: "2025-03-21",
        answerStatus: "답변완료",
        authorName: "강건",
        imageUrls: [
            "https://i.toucheese-macwin.store/resized/TIt02sE.webp",
            "https://i.toucheese-macwin.store/resized/EKuAbP9.webp"
        ]
    )
}
