//
//  UIApplication+HideKeyboard.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/14/24.
//

import Foundation
import UIKit

// MARK: 화면 터치시 키보드를 내려가게 하기 위한 확장자
extension UIApplication {
    func hideKeyboard() {
        guard let windowScene = connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let tapRecognizer = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapRecognizer.cancelsTouchesInView = false
        window.addGestureRecognizer(tapRecognizer)
    }
}
 
extension UIApplication: @retroactive UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
