//
//  StudioDetailViewModel.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/27/24.
//

import Foundation

protocol StudioDetailViewModelProtocol: ObservableObject {
    var studio: Studio { get }
    var studioDetailEntity: StudioDetailEntity { get }
    var reviewList: [StudioReviewEntity] { get }
    
    func fetchStudioDetail() async
    func fetchReviewList() async
}

final class StudioDetailViewModel: StudioDetailViewModelProtocol {
    // MARK: - Data
    @Published private(set) var studio: Studio = Studio.sample
    @Published private(set) var studioDetailEntity: StudioDetailEntity = StudioDetailEntity.sample
    @Published private(set) var reviewList: [StudioReviewEntity] = []
    
    private let studioService = DefaultStudioService(session: SessionManager.shared.baseSession)
    
    let studioId: Int?
    
    init(studio: Studio?, studioId: Int?) {
        self.studio = studio ?? Studio.sample
        self.studioId = studioId
        
        Task {
            async let detail: Void = fetchStudioDetail()
            async let review: Void = fetchReviewList()
            
            _ = await (detail, review)
        }
    }
     
    // MARK: - Logic

    @MainActor
    func fetchStudioDetail() async {
        do {
            studioDetailEntity = try await studioService.getStudioDetail(studioID: studioId ?? studio.id)
        } catch {
            print("Fetch StudioDetail Error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchReviewList() async {
        do {
            reviewList = try await studioService.getStudioReviewList(studioId: studio.id)
        } catch {
            print("Fetch Review Error: \(error.localizedDescription)")
        }
    }
}
