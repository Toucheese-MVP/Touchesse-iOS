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
    @Published var studioLikePath: [ViewType] = [] {
        didSet {
            updateTabBarVisibility()
        }
    }
    
    @Published var tabItem: Tab = .home
    @Published var isTabBarHidden: Bool = false
    
    @Published var isShowingAlert: Bool = false
    @Published var isShowingNicknameView: Bool = false
    
    private(set) var homeResultViewMaterial: HomeResultViewMaterial?
    private(set) var studioDetailViewMaterial: StudioDetailViewMaterial?
    private(set) var productDetailViewMaterial: ProductDetailViewMaterial?
    private(set) var reservationConfirmViewMaterial: ReservationConfirmViewMaterial?
    private(set) var reservationDetailViewMaterial: ReservationDetailViewMaterial?
    
    func goFirstView() {
        switch tabItem {
        case .home:
            homePath.removeAll()
        case .reservation:
            reservationPath.removeAll()
        case .likedStudios:
            studioLikePath.removeAll()
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
        case .likedStudios:
            studioLikePath.removeAll()
            tabItem = .reservation
        case .myPage:
            break
        }
    }
    
    @ViewBuilder
    func buildView(viewType: ViewType) -> some View {
        switch viewType {
        case .homeResultView:
            HomeResultView(concept: self.homeResultViewMaterial!.concept)
        case .studioDetailView:
            StudioDetailView(viewModel: self.studioDetailViewMaterial!.viewModel)
        case .productDetailView:
            ProductDetailView(productDetailViewModel: self.productDetailViewMaterial!.viewModel)
        case .reservationConfirmView:
            ReservationConfirmView(reservationViewModel: self.reservationConfirmViewMaterial!.viewModel)
        case .reservationCompleteView:
            ReservationCompleteView()
            
        case .reservationDetailView:
            ReservationDetailView(viewModel: self.reservationDetailViewMaterial!.viewModel)
        }
    }
    
    func appendPath(viewType: ViewType, viewMaterial: ViewMaterial?) {
        switch viewType {
        case .homeResultView:
            self.homeResultViewMaterial = viewMaterial as? HomeResultViewMaterial
            homePath.append(.homeResultView)
        case .studioDetailView:
            self.studioDetailViewMaterial = viewMaterial as? StudioDetailViewMaterial
            switch tabItem {
            case .home: homePath.append(.studioDetailView)
            case .reservation: reservationPath.append(.studioDetailView)
            case .likedStudios: studioLikePath.append(.studioDetailView)
            default:
                break
            }
        case .productDetailView:
            self.productDetailViewMaterial = viewMaterial as? ProductDetailViewMaterial
            switch tabItem {
            case .home: homePath.append(.productDetailView)
            case .reservation: reservationPath.append(.productDetailView)
            case .likedStudios: studioLikePath.append(.productDetailView)
            default: break
            }
        case .reservationConfirmView:
            self.reservationConfirmViewMaterial = viewMaterial as? ReservationConfirmViewMaterial
            switch tabItem {
            case .home: homePath.append(.reservationConfirmView)
            case .reservation: reservationPath.append(.reservationConfirmView)
            case .likedStudios: studioLikePath.append(.reservationConfirmView)
            default: break
            }
        case .reservationCompleteView:
            switch tabItem {
            case .home: homePath.append(.reservationCompleteView)
            case .reservation: reservationPath.append(.reservationCompleteView)
            case .likedStudios: studioLikePath.append(.reservationCompleteView)
            default: break
            }
        case .reservationDetailView:
            self.reservationDetailViewMaterial = viewMaterial as? ReservationDetailViewMaterial
            reservationPath.append(.reservationDetailView)
        }
    }
    
    private func updateTabBarVisibility() {
        switch tabItem {
        case .home:
            isTabBarHidden = homePath.count >= 2
        case .reservation:
            isTabBarHidden = reservationPath.count >= 1
        case .likedStudios:
            isTabBarHidden = studioLikePath.count >= 1
        case .myPage:
            break
        }
    }
}
