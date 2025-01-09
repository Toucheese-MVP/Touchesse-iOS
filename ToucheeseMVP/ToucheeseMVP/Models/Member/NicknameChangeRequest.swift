//
//  NicknameChangeRequest.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/25/24.
//

import Foundation

struct NicknameChangeRequest {
    let accessToken: String
    
    let memberId: Int
    let newName: String
}
