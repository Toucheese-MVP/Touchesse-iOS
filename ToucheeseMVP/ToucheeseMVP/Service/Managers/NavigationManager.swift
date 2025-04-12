//
//  NavigationManager.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/12/24.
//

import Foundation
import SwiftUI

final class NavigationManager: ObservableObject {
    @Published var homePath: [ViewType] = [] {
        didSet {
            updateTabBarVisibility()
        }
    }
    @Published var reservationPath: [ViewType] = [] {
        didSet {
            updateTabBarVisibility()
        }
    }
    @Published var questionPath: [ViewType] = [] {
        didSet {
            updateTabBarVisibility()
        }
    }
    @Published var studioLikePath: [ViewType] = [] {
        didSet {
            updateTabBarVisibility()
        }
    }
    
    @Published var tabItem: Tab = .home
    @Published var isTabBarHidden: Bool = false
    
    @Published var isShowingAlert: Bool = false
    @Published var isShowingNicknameView: Bool = false
    
    private(set) var productDetailViewMaterial: ProductDetailViewMaterial?
    private(set) var reservationConfirmViewMaterial: ReservationConfirmViewMaterial?
    private(set) var reservationDetailViewMaterial: ReservationDetailViewMaterial?
    
    @MainActor
    func resetNavigationPath(tab: Tab) {
        switch tab {
        case .home:
            homePath.removeAll()
        case .reservation:
            reservationPath.removeAll()
        case .question:
            questionPath.removeAll()
        case .myPage:
            break
        }
    }
    
    func goFirstView() {
        switch tabItem {
        case .home:
            homePath.removeAll()
        case .reservation:
            reservationPath.removeAll()
        case .question:
            questionPath.removeAll()
        case .myPage:
            break
        }
    }
    
    func goFirstViewAndSecondTap() {
        switch tabItem {
        case .home:
            homePath.removeAll()
            tabItem = .reservation
        case .reservation:
            reservationPath.removeAll()
            tabItem = .reservation
        case .question:
            reservationPath.removeAll()
            tabItem = .reservation
        case .myPage:
            break
        }
    }
    
    @ViewBuilder
    func buildView(viewType: ViewType) -> some View {
        switch viewType {
        case .homeResultView(let studioConcept):
            HomeResultView(concept: studioConcept)
        case .studioDetailView(let studio,_,_):
            StudioDetailView(viewModel: StudioDetailViewModel(studio: studio, studioId: studio.id))
        case .productDetailView:
            ProductDetailView(productDetailViewModel: self.productDetailViewMaterial!.viewModel)
        case .reservationConfirmView:
            ReservationConfirmView(viewModel: self.reservationConfirmViewMaterial!.viewModel)
        case .reservationCompleteView:
            ReservationCompleteView()
        case .reviewDetailView:
            ReservationCompleteView()
            // TODO: 리뷰 디테일 뷰 마테리얼 관련 작업 하기
//            ReviewDetailView(viewModel: self.studioDetailViewMaterial!.viewModel,
//                             reviewId: self.studioDetailViewMaterial!.reviewId ?? 1)
        case .reservationDetailView:
            ReservationDetailView(viewModel: self.reservationDetailViewMaterial!.viewModel,
                                  reservation: self.reservationDetailViewMaterial!.reservation)
        case .qustionDetailView(let question):
            QuestionDetailView(viewModel: QuestionDetailViewModel(question: question))
        case .questionCreateView:
            QuestionCreateView(viewModel: QuestionCreateViewModel())
        }
    }
    
    func appendPath(viewType: ViewType, viewMaterial: ViewMaterial?) {
        switch viewType {
        case .homeResultView(let studioConcept):
            homePath.append(.homeResultView(studioConcept: studioConcept))
        case .studioDetailView(let studio, let studioId, let reviewId):
            switch tabItem {
            case .home: homePath.append(.studioDetailView(studio: studio, studioId: studioId, reviewId: reviewId))
            case .reservation: reservationPath.append(.studioDetailView(studio: studio, studioId: studioId, reviewId: reviewId))
            default:
                break
            }
        case .productDetailView:
            self.productDetailViewMaterial = viewMaterial as? ProductDetailViewMaterial
            switch tabItem {
            case .home: homePath.append(.productDetailView)
            case .reservation: reservationPath.append(.productDetailView)
            default: break
            }
        case .reservationConfirmView:
            self.reservationConfirmViewMaterial = viewMaterial as? ReservationConfirmViewMaterial
            switch tabItem {
            case .home: homePath.append(.reservationConfirmView)
            case .reservation: reservationPath.append(.reservationConfirmView)
            default: break
            }
        case .reservationCompleteView:
            switch tabItem {
            case .home: homePath.append(.reservationCompleteView)
            case .reservation: reservationPath.append(.reservationCompleteView)
            default: break
            }
        case .reservationDetailView:
            self.reservationDetailViewMaterial = viewMaterial as? ReservationDetailViewMaterial
            reservationPath.append(.reservationDetailView)
        case .reviewDetailView:
            // TODO: 리뷰 디테일 뷰 마테리얼 관련 작업하기
            // self.studioDetailViewMaterial = viewMaterial as? StudioDetailViewMaterial
            switch tabItem {
            case .home: homePath.append(.reviewDetailView)
            case .reservation: reservationPath.append(.reviewDetailView)
            default: break
            }
        case .qustionDetailView(let question):
            questionPath.append(.qustionDetailView(qustion: question))
        case .questionCreateView:
            questionPath.append(.questionCreateView)
        }
    }
    
    private func updateTabBarVisibility() {
        switch tabItem {
        case .home:
            isTabBarHidden = homePath.count >= 2
        case .reservation:
            isTabBarHidden = reservationPath.count >= 1
        case .question:
            break
        case .myPage:
            break
        }
    }
    
    func pop(_ depth: Int) {
        switch tabItem {
        case .home:
            homePath.removeLast(depth)
        case .reservation:
            reservationPath.removeLast(depth)
        case .question:
            questionPath.removeLast(depth)
        case .myPage:
            break
        }
    }
}
