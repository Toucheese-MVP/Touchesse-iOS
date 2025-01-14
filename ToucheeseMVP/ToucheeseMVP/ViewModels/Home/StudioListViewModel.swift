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
    private var selectedConceptId: Int = 1 {
        didSet {
            if oldValue != selectedConceptId {
                resetStudios()
            }
        }
    }
    @Published private(set) var studios: [Studio] = []
    @Published private(set) var studioCount: Int = 0
    
    @Published var isFilteringByPrice: Bool = false
    @Published var isFilteringByRegion: Bool = false
    @Published private(set) var isFilteringByRating: Bool = false
    var isShowingResetButton: Bool {
        return isFilteringByPrice || isFilteringByRegion || isFilteringByRating
    }
    
    @Published private(set) var selectedPrice: StudioPrice = .all {
        didSet { isFilteringByPrice = selectedPrice != .all }
    }
    @Published private(set) var tempSelectedPrice: StudioPrice = .all
    
    private var selectedRegions: Set<StudioRegion> = [.all] {
        didSet { isFilteringByRegion = selectedRegions != [.all] }
    }
    @Published private(set) var tempSelectedRegions: Set<StudioRegion> = []
    
    @Published private(set) var isStudioLoading: Bool = true
    
    private let networkManager = NetworkManager.shared
    private let authManager = AuthenticationManager.shared
    
    private var page: Int = 1
    
    // MARK: - Migration
    @Published private(set) var studioDatas: [TempStudio] = []
    private var currentPage: Int = 0
    
    // MARK: - Intput
    func resetFilters() {
        isFilteringByPrice = false
        isFilteringByRegion = false
        isFilteringByRating = false
        
        selectedPrice = .all
        selectedRegions = [.all]
        Task { await fetchStudios() }
    }
    
    func applyRegionOptions() {
        selectedRegions = tempSelectedRegions
        Task { await fetchStudios() }
    }
    
    func applyPriceOptions() {
        selectedPrice = tempSelectedPrice
        Task { await fetchStudios() }
    }
    
    // MARK: - Output
    
    
    // MARK: - Logic
    func selectStudioConcept(conceptId: Int) {
        self.selectedConceptId = conceptId
        Task {
            page = 1
            await fetchStudios()
        }
    }
    
    func selectStudioPriceFilter(_ price: StudioPrice) {
        self.tempSelectedPrice = price
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
    
    func completeLoding() {
        isStudioLoading = true
    }
    
    @MainActor
    func loadMoreStudios() {
//        if !isStudioLoading {
//            page += 1
//            
//            let concept = selectedConceptId
//            let isHighRating = isFilteringByRating
//            let regionArray = selectedRegions.map { $0 }
//            let price = selectedPrice
//            let page = page
//            
//            Task {
//                do {
//                    isStudioLoading = true
//                    studios.append(
//                        contentsOf: try await networkManager.getStudioListDatas(
//                            concept: concept,
//                            isHighRating: isHighRating,
//                            regionArray: regionArray,
//                            price: price,
//                            page: page
//                        ).list
//                    )
//                    
//                    isStudioLoading = false
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
//        }
    }
    
    @MainActor
    func fetchStudios() async {
        let conceptId = selectedConceptId
        let currentPage = currentPage
        
        let request = ConceptedStudioRequest(studioConceptId: conceptId)
        
        do {
            let studioEntity = try await networkManager.getConceptedStudioList(conceptedStudioRequest: request)
            studioDatas = studioEntity.studio
            print("studioDatas ====== \(studioDatas)")
            isStudioLoading = false
        } catch {
            print(error.localizedDescription)
        }
        
        
//        let concept = selectedConceptId
//        let isHighRating = isFilteringByRating
//        var regionArray: [StudioRegion] {
//            selectedRegions == [.all] ? [] : Array(selectedRegions)
//        }
//        let price = selectedPrice
//        page = 1
//        
//        do {
//            let studioDatas = try await networkManager.getStudioListDatas(
//                concept: concept,
//                isHighRating: isHighRating,
//                regionArray: regionArray,
//                price: price,
//                page: page
//            )
//            
//            (studios, studioCount) = (studioDatas.list, studioDatas.count)
//            
//            isStudioLoading = false
//        } catch {
//            print(error.localizedDescription)
//        }
    }
    
    private func resetStudios() {
        studios = []
    }
    
    func likeStudio(studioId: Int) async {
        guard authManager.authStatus == .authenticated else {
            print("Failed to like studio: Not authenticated")
            return
        }
        
        do {
            _ = try await networkManager.performWithTokenRetry(
                accessToken: authManager.accessToken,
                refreshToken: authManager.refreshToken) { [unowned self] token in
                    if let memberId = authManager.memberId {
                        let studioLikeRelationRequest = StudioLikeRelationRequest(
                            accessToken: token,
                            memberId: memberId,
                            studioId: studioId
                        )
                        
                        try await networkManager.postStudioLike(studioLikeRelationRequest)
                    } else {
                        print("Failed to like studio: Member ID not found")
                    }
                }
        } catch NetworkError.unauthorized {
            print("Failed to like studio: Refresh token expired")
            await authManager.logout()
        } catch {
            print("Failed to like studio: \(error.localizedDescription)")
        }
    }
    
    func cancelLikeStudio(studioId: Int) async {
        guard authManager.authStatus == .authenticated else {
            print("Failed to cancel like studio: Not authenticated")
            return
        }
        
        do {
            _ = try await networkManager.performWithTokenRetry(
                accessToken: authManager.accessToken,
                refreshToken: authManager.refreshToken
            ) { [unowned self] token in
                if let memberId = authManager.memberId {
                    let studioLikeRelationRequest = StudioLikeRelationRequest(
                        accessToken: token,
                        memberId: memberId,
                        studioId: studioId
                    )
                    
                    try await networkManager.deleteStudioLike(studioLikeRelationRequest)
                } else {
                    print("Failed to cancel like studio: Member ID not found")
                }
            }
        } catch NetworkError.unauthorized {
            print("Failed to cancel like studio: Refresh token expired")
            await authManager.logout()
        } catch {
            print("Failed to cancel like studio: \(error.localizedDescription)")
        }
    }
    
}
