//
//  HomeConceptView.swift
//  Toucheeze
//
//  Created by Healthy on 11/13/24.
//

import SwiftUI

struct HomeConceptView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var studioConceptViewModel: StudioConceptViewModel
    private var tempAuthenticationManager = TempAuthenticationManager.shared
    
    @State private var isShowingLoginView: Bool = false
    
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    private var gridWidthSize: CGFloat {
        (CGFloat.screenWidth - (44 + 12)) / 2
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Color.clear.frame(height: 8)

            LazyVGrid(columns: columns, spacing:12) {
                ForEach(studioConceptViewModel.concepts) { concept in
                    Button {
                        if tempAuthenticationManager.authStatus == .authenticated {
                            navigationManager.appendPath(viewType: .homeResultView, viewMaterial: HomeResultViewMaterial(concept: concept))
                        } else {
                            isShowingLoginView.toggle()
                        }
                    } label: {
                        conceptCardView(imageString: "concept\(concept.id)", concept: concept.shortedName)
                    }
                }
            }
            
            Color.clear.frame(height: 25)
        }
        .padding(.horizontal, 22)
        .background(.white)
        .customNavigationBar {
            Image(.homeLogo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 325)
        }
        .fullScreenCover(isPresented: $isShowingLoginView) {
            TempLoginView(
                TviewModel: TempLogInViewModel(),
                isPresented: $isShowingLoginView
            )
        }
    }
    
    @ViewBuilder
    private func conceptCardView(imageString: String, concept: String) -> some View {
        ZStack(alignment: .bottom) {
            Image(imageString)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: gridWidthSize, height: 232)
                .clipShape(.rect(cornerRadius: 16))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [
                                        Color.black.opacity(0.68),
                                        Color.clear
                                    ]
                                ),
                                startPoint: .bottom,
                                endPoint: .center
                            )
                        )
                }
            
            Text(concept)
                .foregroundStyle(.white)
                .font(.pretendardSemiBold16)
                .padding(.bottom, 15)
        }
    }
}


fileprivate struct ConceptCard: Identifiable, Hashable {
    let id: UUID = UUID()
    let imageString: String
    let concept: StudioConcept
    var title: String {
        concept.title
    }
}

#Preview {
    NavigationStack {
        HomeConceptView()
    }
    .environmentObject(StudioConceptViewModel())
    .environmentObject(StudioListViewModel())
    .environmentObject(NavigationManager())
}
