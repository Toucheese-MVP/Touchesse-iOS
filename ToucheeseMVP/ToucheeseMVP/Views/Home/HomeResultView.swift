//
//  HomeResultView.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/13/24.
//

import SwiftUI

struct HomeResultView: View {
    @EnvironmentObject private var studioListViewModel: StudioListViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    
    @Environment(\.dismiss) private var dismiss
    
    let concept: StudioConceptEntity
    
    @State private var isShowingPriceFilterOptionView: Bool = false
    @State private var isShowingRegionFilterOptionView: Bool = false
    @State private var isShowingRatingFilterOptionView: Bool = false
    
    @State private var isShowingLoginAlert: Bool = false
    @State private var isShowingLoginView: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                filtersView
                    .padding(.horizontal)
                    .padding(.top, 11)
                    .padding(.bottom, -5)
                
                ZStack(alignment: .top) {
                    if studioListViewModel.studioDatas.isEmpty && studioListViewModel.isStudioLoading == false {
                        CustomEmptyView(
                            viewType: .studio(
                                buttonAction: {
                                    studioListViewModel.resetFilters()
                                },
                                buttonText: "필터링 초기화 하기")
                        )
                    } else {
                        ScrollView {
                            Color.clear
                                .frame(height: 5)
                            
                            LazyVStack(spacing: 20) {
                                HStack(spacing: 0) {
                                    Text("총")
                                        .padding(.trailing, 3)
                                    
                                    Text("\(studioListViewModel.studioCount)")
                                        .foregroundStyle(.tcPrimary06)
                                        .font(.pretendardMedium14)
                                    
                                    Text("개의 스튜디오가 있습니다.")
                                    
                                    Spacer()
                                }
                                .foregroundStyle(.tcGray10)
                                .font(.pretendardRegular14)
                                .padding(.horizontal, 16)
                                
                                ForEach(studioListViewModel.studioDatas) { studio in
                                    StudioRow(
                                        studio: studio,
                                        isShowingLoginAlert: $isShowingLoginAlert
                                    )
                                    .contentShape(.rect)
                                    .onTapGesture {
                                        navigationManager.appendPath(
                                            viewType: .studioDetailView,
                                            viewMaterial: StudioDetailViewMaterial(
                                                viewModel: StudioDetailViewModel(
                                                    studio: studio, studioId: studio.id
                                                )
                                            )
                                        )
                                    }
                                }
                                
                                Color.clear
                                    .onAppear {
                                        Task {
                                            await studioListViewModel.loadMoreStudios()
                                        }
                                    }
                            }
                        }
                        .scrollIndicators(.never)
                    }
                }
            }
            .customNavigationBar(centerView: {
                Text("\(concept.name)")
                    .modifier(NavigationTitleModifier())
            }, leftView: {
                Button {
                    dismiss()
                } label: {
                    NavigationBackButtonView()
                }
            })
            
            if isShowingLoginAlert {
                CustomAlertView(
                    isPresented: $isShowingLoginAlert,
                    alertType: .login
                ) {
                    isShowingLoginView.toggle()
                }
            }
        }
        .sheet(isPresented: $isShowingPriceFilterOptionView) {
            filterOptionView(StudioFilter.price)
                .presentationDetents([.fraction(0.5)])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isShowingRegionFilterOptionView) {
            filterOptionView(StudioFilter.region)
                .presentationDetents([.fraction(0.9)])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isShowingRatingFilterOptionView) {
            filterOptionView(StudioFilter.rating)
                .presentationDetents([.fraction(0.6)])
                .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $isShowingLoginView) {
            LoginView(TviewModel: LogInViewModel(),
                          isPresented: $isShowingLoginView)
        }
        .onAppear {
            studioListViewModel.selectStudioConcept(conceptId: concept.id)
            studioListViewModel.completeLoding()
        }
    }
    
    private var filtersView: some View {
        HStack(spacing: 6) {
            if studioListViewModel.isShowingResetButton {
                Button {
                    isShowingRegionFilterOptionView = false
                    isShowingPriceFilterOptionView = false
                    isShowingRatingFilterOptionView = false
                    
                    studioListViewModel.resetFilters()
                } label: {
                    Image(.tcRefresh)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(Color.black)
                }
                .buttonStyle(.plain)
            }
            
            Button {
                toggleFilter(&isShowingPriceFilterOptionView)
            } label: {
                FilterButtonView(
                    filter: .price,
                    isFiltering: studioListViewModel.isFilteringByPrice
                )
            }
            .buttonStyle(.plain)
            
            Button {
                toggleFilter(&isShowingRegionFilterOptionView)
            } label: {
                FilterButtonView(
                    filter: .region,
                    isFiltering: studioListViewModel.isFilteringByRegion
                )
            }
            .buttonStyle(.plain)
            
            Button {
                toggleFilter(&isShowingRatingFilterOptionView)
            } label: {
                FilterButtonView(
                    filter: .rating,
                    isFiltering: studioListViewModel.isFilteringByRating
                )
            }
            
            Spacer()
        }
        .frame(height: 34)
    }
    
    @ViewBuilder
    private func filterOptionView(_ filter: StudioFilter) -> some View {
        VStack(spacing: 16) {
            LeadingTextView(
                text: "\(filter.title)",
                font: .pretendardSemiBold(20)
            )
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(filter.options, id: \.id) { option in
                        if let region = option as? StudioRegion {
                            filterOptionButton(
                                for: region,
                                isSelected: studioListViewModel.tempSelectedRegions.contains(region)
                            )
                        } else if let price = option as? StudioPrice {
                            filterOptionButton(
                                for: price,
                                isSelected: price == studioListViewModel.tempSelectedPrice
                            )
                        } else if let rating = option as? StudioRating {
                            filterOptionButton(
                                for: rating,
                                isSelected: rating == studioListViewModel.tempSelectedRating
                            )
                        }
                    }
                }
            }
            
            FillBottomButton(isSelectable: true, title: "적용하기") {
                switch filter {
                case .region:
                    studioListViewModel.applyRegionOptions()
                    isShowingRegionFilterOptionView = false
                case .price:
                    studioListViewModel.applyPriceOptions()
                    isShowingPriceFilterOptionView = false
                case .rating:
                    studioListViewModel.applyRatingOptions()
                    isShowingRatingFilterOptionView = false
                }
            }
        }
        .padding(.top, 32)
        .padding(.horizontal, 24)
        .onAppear {
            studioListViewModel.loadRegionOptions()
            studioListViewModel.loadPriceOptions()
            studioListViewModel.loadRatingOptions()
        }
    }
    
    private func filterOptionButton<T: OptionType>(
        for option: T,
        isSelected: Bool
    ) -> some View {
        Button {
            if let region = option as? StudioRegion {
                studioListViewModel.toggleRegionFilterOption(region)
            } else if let price = option as? StudioPrice {
                studioListViewModel.selectStudioPriceFilter(price)
            } else if let rating = option as? StudioRating {
                studioListViewModel.selectStudioRatingFilter(studioRating: rating)
            }
        } label: {
            HStack {
                Text("\(option.title)")
                    .foregroundStyle(.tcGray10)
                    .font(isSelected ? .pretendardBold(16) : .pretendardRegular16)
                
                Spacer()
                
                if isSelected {
                    Image(.tcCheckmark)
                        .resizable()
                        .frame(width: 28, height: 28)
                        .scaledToFit()
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .tcPrimary01 : .clear)
            )
        }
    }
    
    private func toggleFilter(_ filter: inout Bool) {
        if !filter {
            isShowingPriceFilterOptionView = false
            isShowingRegionFilterOptionView = false
            isShowingRatingFilterOptionView = false
        }
        
        filter.toggle()
    }
}

#Preview {
    NavigationStack {
        HomeResultView(concept: StudioConceptEntity(id: 1, name: "생동감 있는 실물 느낌"))
    }
    .environmentObject(StudioListViewModel())
    .environmentObject(NavigationManager())
}
