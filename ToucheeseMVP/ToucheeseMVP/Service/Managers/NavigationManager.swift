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
        case .studioDetailView(let studio,_):
            StudioDetailView(viewModel: StudioDetailViewModel(studio: studio, studioId: studio.id))
        case .productDetailView(let studio, let studioDetail, let product):
            ProductDetailView(productDetailViewModel: ProductDetailViewModel(studio: studio, studioDetails: studioDetail, product: product))
        case .reservationConfirmView(
            let studio,
            let studioDetail,
            let product,
            let productDetail,
            let productOption,
            let reservationDate,
            let totalPrice,
            let addPeopleCount
        ):
            ReservationConfirmView(
                viewModel: ReservationViewModel(
                    studio: studio,
                    studioDetail: studioDetail,
                    product: product,
                    productDetail: productDetail,
                    productOptions: productOption,
                    reservationDate: reservationDate,
                    totalPrice: totalPrice,
                    addPeopleCount: addPeopleCount
                )
            )
        case .reservationCompleteView:
            ReservationCompleteView()
        case .reviewDetailView(let studio, let reviewId):
            // TODO: reviewDetailView가 studioDetailView의 뷰모델 인스턴스를 만들고 있습니다. 뷰모델 분리가 필요할 것 같습니다.
            ReviewDetailView(
                viewModel: StudioDetailViewModel(
                    studio: studio,
                    studioId: studio.id
                ),
                reviewId: reviewId
            )
        case .reservationDetailView(let reservation):
            ReservationDetailView(viewModel: ReservationDetailViewModel(reservation: reservation), reservation: reservation)
        case .qustionDetailView(let question):
            QuestionDetailView(viewModel: QuestionDetailViewModel(question: question))
        case .questionCreateView:
            QuestionCreateView(viewModel: QuestionCreateViewModel())
        }
    }
    
    func appendPath(viewType: ViewType) {
        switch viewType {
        case .homeResultView(let studioConcept):
            homePath.append(.homeResultView(studioConcept: studioConcept))
        case .studioDetailView(let studio, let reviewId):
            switch tabItem {
            case .home: homePath.append(.studioDetailView(studio: studio, reviewId: reviewId))
            case .reservation: reservationPath.append(.studioDetailView(studio: studio, reviewId: reviewId))
            default:
                break
            }
        case .productDetailView(let studio, let studioDetail, let product):
            switch tabItem {
            case .home: homePath.append(.productDetailView(studio: studio, studioDetail: studioDetail, product: product))
            case .reservation: reservationPath.append(.productDetailView(studio: studio, studioDetail: studioDetail, product: product))
            default: break
            }
        case .reservationConfirmView(
            let studio,
            let studioDetail,
            let product,
            let productDetail,
            let productOption,
            let reservationDate,
            let totalPrice,
            let addPeopleCount
        ):
            switch tabItem {
            case .home: homePath.append(
                .reservationConfirmView(
                    studio: studio,
                    studioDetail: studioDetail,
                    product: product,
                    productDetail: productDetail,
                    productOption: productOption,
                    reservationDate: reservationDate,
                    totalPrice: totalPrice,
                    addPeopleCount: addPeopleCount
                )
            )
                
            case .reservation: reservationPath.append(
                .reservationConfirmView(
                    studio: studio,
                    studioDetail: studioDetail,
                    product: product,
                    productDetail: productDetail,
                    productOption: productOption,
                    reservationDate: reservationDate,
                    totalPrice: totalPrice,
                    addPeopleCount: addPeopleCount
                )
            )
            default: break
            }
        case .reservationCompleteView:
            switch tabItem {
            case .home: homePath.append(.reservationCompleteView)
            case .reservation: reservationPath.append(.reservationCompleteView)
            default: break
            }
        case .reservationDetailView(let reservation):
            reservationPath.append(.reservationDetailView(reservation: reservation))
        case .reviewDetailView(let studio, let reviewId):
            switch tabItem {
            case .home: homePath.append(.reviewDetailView(studio: studio, reviewId: reviewId))
            case .reservation: reservationPath.append(.reviewDetailView(studio: studio, reviewId: reviewId))
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
