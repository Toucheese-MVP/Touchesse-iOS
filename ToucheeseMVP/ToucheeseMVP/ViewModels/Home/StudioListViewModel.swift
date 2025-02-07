//
//  HomeResultViewModel.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/13/24.
//

import Foundation
import SwiftUI

final class StudioListViewModel: ObservableObject {
    // MARK: - Data
    // 네트워크 매니저
    private let networkManager = NetworkManager.shared
    
    // 계정 및 권한 매니저
    private let authManager = AuthenticationManager.shared
    
    // 선택된 컨셉 ID
    private var selectedConceptId: Int = 1 {
        didSet {
            if oldValue != selectedConceptId {
                resetStudios()
            }
        }
    }
    
    // 페이징 처리를 위한 현재 페이지 정보
    private var currentPage: Int = 0
    private var isLastPage: Bool = false
    
    
    // MARK: - Data: Studio
    // 메모리에 있는 스튜디오 데이터
    @Published private(set) var studioDatas: [TempStudio] = []
    
    // 메모리에 있는 스튜디오 데이터의 수
    @Published private(set) var studioCount: Int = 0
    
    // 스튜디오를 불러오는 중인지 여부
    @Published private(set) var isStudioLoading: Bool = true
    
    
    // MARK: Data: Filter Options
    // 선택된 평점 필터
    @Published private(set) var selectedRating: StudioRating = .all {
        didSet { isFilteringByRating = selectedRating != .all }
    }
    
    // 선택된 가격 필터
    @Published private(set) var selectedPrice: StudioPrice = .all {
        didSet { isFilteringByPrice = selectedPrice != .all }
    }
    
    // 선택된 지역 필터
    private var selectedRegions: Set<StudioRegion> = [.all] {
        didSet { isFilteringByRegion = selectedRegions != [.all] }
    }
    
    // 선택된 임시 평점 필터
    @Published private(set) var tempSelectedRating: StudioRating = .all
    
    // 선택된 임시 가격 필터
    @Published private(set) var tempSelectedPrice: StudioPrice = .all
    
    // 선택된 임시 지역 필터
    @Published private(set) var tempSelectedRegions: Set<StudioRegion> = []
    
    // 필터 정렬이 되어있는지 여부
    @Published private(set) var isFilteringByRating: Bool = false
    @Published private(set) var isFilteringByPrice: Bool = false
    @Published private(set) var isFilteringByRegion: Bool = false
    
    // 필터 리셋 버튼을 보이는지에 대한 변수
    var isShowingResetButton: Bool {
        return isFilteringByPrice || isFilteringByRegion || isFilteringByRating
    }
    
    
    // MARK: - Intput
    func resetFilters() {
        isFilteringByPrice = false
        isFilteringByRegion = false
        isFilteringByRating = false
        
        selectedPrice = .all
        selectedRegions = [.all]
        selectedRating = .all
        Task { await fetchStudios() }
    }
    
    func applyRegionOptions() {
        selectedRegions = tempSelectedRegions
        currentPage = 0
        Task { await fetchStudios() }
    }
    
    func applyPriceOptions() {
        selectedPrice = tempSelectedPrice
        currentPage = 0
        Task { await fetchStudios() }
    }
    
    func applyRatingOptions() {
        selectedRating = tempSelectedRating
        currentPage = 0
        Task { await fetchStudios() }
    }
    
    // MARK: - Output
    
    
    // MARK: - Logic
    func selectStudioConcept(conceptId: Int) {
        self.selectedConceptId = conceptId
        Task {
            currentPage = 0
            await fetchStudios()
        }
    }
    
    func selectStudioPriceFilter(_ price: StudioPrice) {
        self.tempSelectedPrice = price
    }
    
    func selectStudioRatingFilter(studioRating: StudioRating) {
        self.tempSelectedRating = studioRating
    }
    
    func toggleStudioRatingFilter() {
        self.isFilteringByRating.toggle()
        Task { await fetchStudios() }
    }
    
    func toggleRegionFilterOption(_ option: StudioRegion) {
        if option != .all {
            tempSelectedRegions.remove(.all)
            
            if tempSelectedRegions.contains(option) {
                tempSelectedRegions.remove(option)
                if tempSelectedRegions.isEmpty {
                    tempSelectedRegions.insert(.all)
                }
            } else {
                tempSelectedRegions.insert(option)
            }
        } else {
            tempSelectedRegions = []
            tempSelectedRegions.insert(.all)
        }
    }
    
    func loadPriceOptions() {
        tempSelectedPrice = selectedPrice
    }
    
    func loadRegionOptions() {
        tempSelectedRegions = selectedRegions
    }
    
    func loadRatingOptions() {
        tempSelectedRating = selectedRating
    }
    
    func completeLoding() {
        isStudioLoading = true
    }
    
    @MainActor
    func loadMoreStudios() async {
        if !isStudioLoading && !isLastPage {
            isStudioLoading = true
            
            let conceptId = selectedConceptId
            let price = selectedPrice.querryParameter
            let rating = selectedRating.querryParameter
            
            var regionArray: [String] {
                selectedRegions == [.all] ? [] : selectedRegions.map(\.self.querryParameter)
            }
            
            let request = ConceptedStudioRequest(
                studioConceptId: conceptId,
                page: currentPage + 1,
                price: price,
                rating: rating,
                location: regionArray
            )
            
            do {
                let studioEntity = try await networkManager.getConceptedStudioList(conceptedStudioRequest: request)
                
                studioDatas += studioEntity.studio
                currentPage = studioEntity.pageable.pageNumber
                isLastPage = studioEntity.last
                
                isStudioLoading = false
            } catch {
                print(error.localizedDescription)
                isStudioLoading = false
            }
        }
    }
    
    @MainActor
    /// StudioData를 네트워크에서 불러오는 함수
    func fetchStudios() async {
        let conceptId = selectedConceptId
        let price = selectedPrice.querryParameter
        let rating = selectedRating.querryParameter
        
        var regionArray: [String] {
            selectedRegions == [.all] ? [] : selectedRegions.map(\.self.querryParameter)
        }
        
        let request = ConceptedStudioRequest(
            studioConceptId: conceptId,
            page: currentPage,
            price: price,
            rating: rating,
            location: regionArray
        )
        
        do {
            let studioEntity = try await networkManager.getConceptedStudioList(conceptedStudioRequest: request)
            
            studioDatas = studioEntity.studio
            currentPage = studioEntity.pageable.pageNumber
            isLastPage = studioEntity.last
            
            isStudioLoading = false
        } catch {
            print(error.localizedDescription)
            isStudioLoading = false
        }
    }
    
    private func resetStudios() {
        studioDatas = []
    }
    
    func likeStudio(studioId: Int) async {
        guard authManager.authStatus == .authenticated else {
            print("Failed to like studio: Not authenticated")
            return
        }
        
        // MARK: 찜하기 로직을 적용해야 함
//        do {
//            _ = try await networkManager.performWithTokenRetry(
//                accessToken: authManager.accessToken,
//                refreshToken: authManager.refreshToken) { [unowned self] token in
//                    if let memberId = authManager.memberId {
//                        let studioLikeRelationRequest = StudioLikeRelationRequest(
//                            accessToken: token,
//                            memberId: memberId,
//                            studioId: studioId
//                        )
//                        
//                        try await networkManager.postStudioLike(studioLikeRelationRequest)
//                    } else {
//                        print("Failed to like studio: Member ID not found")
//                    }
//                }
//        } catch NetworkError.unauthorized {
//            print("Failed to like studio: Refresh token expired")
//            await authManager.logout()
//        } catch {
//            print("Failed to like studio: \(error.localizedDescription)")
//        }
    }
    
    func cancelLikeStudio(studioId: Int) async {
        guard authManager.authStatus == .authenticated else {
            print("Failed to cancel like studio: Not authenticated")
            return
        }
        
        // MARK: 찜하기 취소 로직을 적용해야 함
//        do {
//            _ = try await networkManager.performWithTokenRetry(
//                accessToken: authManager.accessToken,
//                refreshToken: authManager.refreshToken
//            ) { [unowned self] token in
//                if let memberId = authManager.memberId {
//                    let studioLikeRelationRequest = StudioLikeRelationRequest(
//                        accessToken: token,
//                        memberId: memberId,
//                        studioId: studioId
//                    )
//                    
//                    try await networkManager.deleteStudioLike(studioLikeRelationRequest)
//                } else {
//                    print("Failed to cancel like studio: Member ID not found")
//                }
//            }
//        } catch NetworkError.unauthorized {
//            print("Failed to cancel like studio: Refresh token expired")
//            await authManager.logout()
//        } catch {
//            print("Failed to cancel like studio: \(error.localizedDescription)")
//        }
    }
}
