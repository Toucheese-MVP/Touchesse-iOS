//
//  BackbButtonView.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 1/17/25.
//

import SwiftUI

struct BackbButtonView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                navigationManager.pop(1)
            } label: {
                NavigationBackButtonView()
            }
            .padding(.trailing, 11)
        }
    }
}

#Preview {
    BackbButtonView()
}
