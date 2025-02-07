//
//  Temp.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/19/24.
//

import Foundation

// MARK: Secret 내부의 값들을 가져오기 위한 확장자
extension Bundle {
    /// Bundle의 서버 URL 값
    var serverURL: String {
        guard let result = infoDictionary?["SERVER_URL"] as? String else {
            return "ERROR"
        }
        
        return result
    }
    
    /// Bundle의 카카오 App-Key 값
    var kakaoNativeAppKey: String {
        guard let result = infoDictionary?["KAKAO_NATIVE_APPKEY"] as? String else {
            return "ERROR"
        }
        
        return result
    }
}
