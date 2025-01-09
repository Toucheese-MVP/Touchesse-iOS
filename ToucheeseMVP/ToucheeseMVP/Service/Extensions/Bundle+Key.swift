//
//  Temp.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/19/24.
//

import Foundation

extension Bundle {
    var serverURL: String {
        guard let result = infoDictionary?["SERVER_URL"] as? String else {
            return "ERROR"
        }
        
        return result
    }
    
    var kakaoNativeAppKey: String {
        guard let result = infoDictionary?["KAKAO_NATIVE_APPKEY"] as? String else {
            return "ERROR"
        }
        
        return result
    }
}
