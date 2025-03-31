//
//  File.swift
//  ToucheeseMVP
//
//  Created by 강건 on 3/14/25.
//

import Foundation

struct QuestionRequest: RequestWithImageProtocol {
    let title: String
    let content: String
    let imageArray: [Data]
    let imageRequestName = "uploadFiles"
}
