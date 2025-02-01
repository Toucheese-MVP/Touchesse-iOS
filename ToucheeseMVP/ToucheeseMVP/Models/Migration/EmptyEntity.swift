//
//  EmptyEntity.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 2/1/25.
//

import Foundation

// 빈 구조체를 디코딩할 때 사용
struct EmptyEntity: Decodable {
    let status: Int?
    let message: String?
}
