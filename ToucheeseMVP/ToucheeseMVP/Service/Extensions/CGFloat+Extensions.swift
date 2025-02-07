//
//  CGFloat+ScreenSize.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/27/24.
//

import SwiftUI

// MARK: 화면 넓이와 높이를 가져오기 위한 확장자
extension CGFloat {
    /// 기기의 화면 너비
    ///
    /// **주의** 화면이 회전하는 경우 대응 불가능
    static let screenWidth = UIScreen.main.bounds.width
    
    /// 기기의 화면 높이
    ///
    /// **주의** 화면이 회전하는 경우 대응 불가능
    static let screenHeight = UIScreen.main.bounds.height
}
