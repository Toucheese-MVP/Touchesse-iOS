//
//  ContentView.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/13/24.
//

import SwiftUI

struct ToucheeseTabView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @StateObject private var reservationListViewModel = ReservationListViewModel()
    @StateObject private var questionViewModel = QuestionViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            switch navigationManager.tabItem {
            case .home:
                NavigationStack(path: $navigationManager.homePath) {
                    HomeConceptView()
                        .navigationDestination(for: ViewType.self) { viewType in
                            navigationManager.buildView(viewType: viewType)
                        }
                }
            case .reservation:
                NavigationStack(path: $navigationManager.reservationPath) {
                    ReservationListView(viewModel: reservationListViewModel)
                        .navigationDestination(for: ViewType.self) { viewType in
                            navigationManager.buildView(viewType: viewType)
                        }
                }
                //            case .likedStudios:
                //                NavigationStack(path: $navigationManager.studioLikePath) {
                //                    StudioLikeListView()
                //                        .navigationDestination(for: ViewType.self) { viewType in
                //                            navigationManager.buildView(viewType: viewType)
                //                        }
                //                }
            case .question:
                NavigationStack(path: $navigationManager.questionPath) {
                    QuestionView(viewModel: questionViewModel)
                        .navigationDestination(for: ViewType.self) { viewType in
                            navigationManager.buildView(viewType: viewType)
                        }
                }
            case .myPage:
                MyPageView(myPageViewModel: TempMyPageViewModel(navigationManager: navigationManager))
            }
            
            if !navigationManager.isTabBarHidden, !navigationManager.isShowingNicknameView {
                CustomTabBar(
                    selectedTab: $navigationManager.tabItem,
                    isShowingAlert: $navigationManager.isShowingAlert
                )
            }
        }
    }
}


#Preview {
    ToucheeseTabView()
        .environmentObject(NavigationManager())
        .environmentObject(StudioConceptViewModel())
}
