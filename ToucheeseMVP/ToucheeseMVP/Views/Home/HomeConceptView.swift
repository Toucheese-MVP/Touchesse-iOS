//
//  HomeConceptView.swift
//  Toucheeze
//
//  Created by Healthy on 11/13/24.
//

import SwiftUI

struct HomeConceptView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    private let conceptCards: [ConceptCard] = [
        ConceptCard(imageString: "flashIdol", concept: .flashIdol),
        ConceptCard(imageString: "liveliness", concept: .liveliness),
        ConceptCard(imageString: "blackBlueActor", concept: .blackBlueActor),
        ConceptCard(imageString: "naturalPictorial", concept: .naturalPictorial),
        ConceptCard(imageString: "waterColor", concept: .waterColor),
        ConceptCard(imageString: "clarityDoll", concept: .gorgeous)
    ]
    
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
                ForEach(conceptCards) { conceptCard in
                    Button {
                        navigationManager.appendPath(viewType: .homeResultView, viewMaterial: HomeResultViewMaterial(concept: conceptCard.concept))
                    } label: {
                        conceptCardView(conceptCard)
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
    }
    
    @ViewBuilder
    private func conceptCardView(_ conceptCard: ConceptCard) -> some View {
        ZStack(alignment: .bottom) {
            Image(conceptCard.imageString)
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
            
            Text(conceptCard.title)
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
    .environmentObject(StudioListViewModel())
    .environmentObject(NavigationManager())
}
