//
//  ConceptButtomModifier.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/13/24.
//

import SwiftUI

// ViewModifier
struct ConceptButtonModifier: ViewModifier {
    
    // ViewModifier 안에서 body를 넣어줘야 하는데 일반적인 body가 아닌 some View를 리턴하는 함수의 형태이다.
    func body(content: Content) -> some View {
        content
            .frame(width: 160, height: 200)
            .foregroundStyle(Color.black)
            .background(Color.gray)
    }
}
