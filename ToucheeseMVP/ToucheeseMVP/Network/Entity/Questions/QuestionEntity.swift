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

struct Question: Decodable {
    let id: Int
    let title: String
    let content: String
    let createDate: String
    let answerStatus: String
    let authorName: String
    let imageUrls: [Data]
}
