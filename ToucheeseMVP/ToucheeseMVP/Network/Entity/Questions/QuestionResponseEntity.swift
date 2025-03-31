//
//  QuestionResponseEntity.swift
//  ToucheeseMVP
//
//  Created by 강건 on 3/30/25.
//

import Foundation

struct QuestionResponseEntity: Decodable {
    let questionResponse: QuestionResponse
    
    enum CodingKeys: String, CodingKey {
        case questionResponse = "answerResponse"
    }
}

struct QuestionResponse: Decodable {
    let id: Int
    let title: String
    let content: String
    let createDate: String
}

extension QuestionResponse {
    static let sample1: QuestionResponse = QuestionResponse(
        id: 3,
        title: "답변 드립니다~~",
        content: "사진이 마음에 안드셔서 속상하겠군요!",
        createDate: "2025-03-30"
    )
}
