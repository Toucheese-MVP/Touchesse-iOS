//
//  ReviewCreateViewModel.swift
//  ToucheeseMVP
//
//  Created by 최주리 on 4/1/25.
//

import Foundation

protocol ReviewCreateViewModelProtocol: ObservableObject {
    var reservation: Reservation { get }
    var content: String { get set }
    var rating: Int { get set }
    var isPosting: Bool { get }
    func postReview(_ imageData: [Data]) async
}

final class ReviewCreateViewModel: ReviewCreateViewModelProtocol {
    private let reviewService = DefaultStudioService(session: SessionManager.shared.authSession)
    private(set) var reservation: Reservation
    @Published var content: String = ""
    @Published var rating: Int = 0
    @Published private(set) var isPosting: Bool = false
    
    init(reservation: Reservation) {
        self.reservation = reservation
    }
    
    //MARK: - Network
    
    // 리뷰 작성
    @MainActor
    func postReview(_ imageData: [Data]) async {
        await MainActor.run {
            isPosting = true
        }
        
        do {
            let request: ReviewRequest = .init(
                studioID: reservation.studioId,
                productID: reservation.productId,
                content: content,
                rating: rating,
                imageArray: imageData
            )
            try await reviewService.postReview(request)
            
            isPosting = false
        } catch {
            print("리뷰 작성 실패: \(error.localizedDescription)")
        }
    }
}

