//
//  StudioDetailViewModel.swift
//  TOUCHEESE
//
//  Created by 김성민 on 11/27/24.
//

import Foundation

final class StudioDetailViewModel: ObservableObject {
    
    // MARK: - Data
    @Published private(set) var studio: Studio
    @Published private(set) var studioDetail: StudioDetail = StudioDetail.sample
    
    @Published private(set) var reviewDetail: ReviewDetail = ReviewDetail.sample
    
    let networkManager = NetworkManager.shared
        
    init(studio: Studio) {
        self.studio = studio
        
        Task {
            await fetchStudioDetail(studioID: studio.id)
        }
    }
    
    
    // MARK: - Output
    var businessHourString: String {
        var basicString = "\(studioDetail.openTimeString)~\(studioDetail.closeTimeString)"
        
        if !studioDetail.holidayString.isEmpty {
            basicString += " / 매주 \(studioDetail.holidayString) 휴무"
        } else {
            basicString += " / 휴무일 없음"
        }
        
        return basicString
    }
    
    
    // MARK: - Logic
    @MainActor
    func fetchStudioDetail(studioID id: Int) async {
        do {
            studioDetail = try await networkManager.getStudioDetailData(studioID: id)
        } catch {
            print("Fetch StudioDetail Error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func fetchReviewDetail(reviewID: Int) async {
        do {
            reviewDetail = try await networkManager.getReviewDetailData(
                studioID: studio.id,
                reviewID: reviewID
            )
        } catch {
            print("Fetch ReviewDetail Error: \(error.localizedDescription)")
        }
    }
    
    // Test 코드, 불필요시 지우기
    func fetchProductDetail(productID: Int) async {
        do {
            dump(try await networkManager.getProductDetailData(productID: productID))
        } catch {
            print("Fetch ProductDetail Error: \(error.localizedDescription)")
        }
    }
}
