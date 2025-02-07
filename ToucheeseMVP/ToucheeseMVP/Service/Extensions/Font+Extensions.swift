//
//  Font+UseCase.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/11/24.
//

import Foundation
import SwiftUICore

extension Font {
    // Bold
    static let pretendardBold13: Font = .custom("Pretendard-Bold", size: 13)
    static let pretendardBold18: Font = .custom("Pretendard-Bold", size: 18)
    static let pretendardBold20: Font = .custom("Pretendard-Bold", size: 20)
    
    // SemiBold
    static let pretendardSemiBold14: Font = .custom("Pretendard-SemiBold", size: 14)
    static let pretendardSemiBold16: Font = .custom("Pretendard-SemiBold", size: 16)
    static let pretendardSemiBold18: Font = .custom("Pretendard-SemiBold", size: 18)
    static let pretendardSemiBold22: Font = .custom("Pretendard-SemiBold", size: 22)
    static let pretendardSemiBold24: Font = .custom("Pretendard-SemiBold", size: 24)

    
    // Medium
    static let pretendardMedium11: Font = .custom("Pretendard-Medium", size: 11)
    static let pretendardMedium12: Font = .custom("Pretendard-Medium", size: 12)
    static let pretendardMedium13: Font = .custom("Pretendard-Medium", size: 13)
    static let pretendardMedium14: Font = .custom("Pretendard-Medium", size: 14)
    static let pretendardMedium16: Font = .custom("Pretendard-Medium", size: 16)
    static let pretendardMedium18: Font = .custom("Pretendard-Medium", size: 18)
    
    // Regular
    static let pretendardRegular12: Font = .custom("Pretendard-Regular", size: 12)
    static let pretendardRegular13: Font = .custom("Pretendard-Regular", size: 13)
    static let pretendardRegular14: Font = .custom("Pretendard-Regular", size: 14)
    static let pretendardRegular16: Font = .custom("Pretendard-Regular", size: 16)
    
    /// Pretendard-Bold 폰트
    static func pretendardBold(_ size: CGFloat) -> Font {
        return .custom("Pretendard-Bold", size: size)
    }

    /// Pretendard-SemiBold 폰트
    static func pretendardSemiBold(_ size: CGFloat) -> Font {
        return .custom("Pretendard-SemiBold", size: size)
    }
    
    /// Pretendard-Medium 폰트
    static func pretendardMedium(_ size: CGFloat) -> Font {
        return .custom("Pretendard-Medium", size: size)
    }
    
    /// Pretendard-Regular 폰트
    static func pretendardRegular(_ size: CGFloat) -> Font {
        return .custom("Pretendard-Regular", size: size)
    }
}
