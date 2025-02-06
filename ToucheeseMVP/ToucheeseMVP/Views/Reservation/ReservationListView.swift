//
//  ReservationListView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/7/24.
//

import SwiftUI

struct ReservationListView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var viewModel: ReservationListViewModel
    
    @Namespace private var namespace
    
    @State private var selectedIndex = 0
    @State private var activeTab: SegmentedTab = .reservation
    
    @State private var isShowingLogInView = false
    
    private let authManager = AuthenticationManager.shared
    
    var body: some View {
        VStack {
            if authManager.authStatus == .notAuthenticated {
                CustomEmptyView(viewType: .requiredLogIn(buttonText: "로그인 하기") {
                    isShowingLogInView.toggle()
                })
            } else {
                ReservationCustomSegmentedControl(
                    tabs: SegmentedTab.allCases,
                    activeTab: $activeTab,
                    namespace: namespace
                )
                .padding(.top, 11)
                
                switch activeTab {
                case .reservation:
                    FilteredReservationListView(
                        reservations: viewModel.reservations
                    ) {
                        CustomEmptyView(viewType: .reservation)
                    } refreshAction: {
                        Task {
                            await viewModel.fetchReservations()
                        }
                    }
                case .history:
                    FilteredReservationListView(
                        reservations: viewModel.pastReservations
                    ) {
                        CustomEmptyView(viewType: .pastReservation)
                    } refreshAction: {
                        Task {
                            await viewModel.fetchPastReservations()
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .fullScreenCover(isPresented: $isShowingLogInView) {
            LogInView(isPresented: $isShowingLogInView)
        }
        .customNavigationBar {
            Text("예약 내역")
                .modifier(NavigationTitleModifier())
        }
        .onChange(of: isShowingLogInView) { _ in
            Task {
                await viewModel.fetchReservations()
                await viewModel.fetchPastReservations()
            }
        }
    }
}


fileprivate struct FilteredReservationListView<Content>: View where Content: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    
    var reservations: [Reservation]
    @ViewBuilder let emptyView: Content
    let refreshAction: () -> Void
    
    var body: some View {
        if reservations.isEmpty {
            emptyView
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                Color.clear
                    .frame(height: 20)
                
                LazyVStack(spacing: 8) {
                    ForEach(reservations) { reservation in
                        Button {
                            navigationManager.appendPath(
                                viewType: .reservationDetailView,
                                viewMaterial: ReservationDetailViewMaterial(viewModel: ReservationDetailViewModel(reservation: reservation), tempViewModel: TempReservationDetailViewModel(reservation: reservation))
                            )
                        } label: {
                            ReservationRow(reservation: reservation)
                        }
                    }
                }
                
                Color.clear
                    .frame(height: 25)
            }
            .refreshable {
                refreshAction()
            }
            .animation(.easeInOut, value: reservations)
        }
    }
}


fileprivate struct ReservationCustomSegmentedControl: View {
    var tabs: [SegmentedTab]
    @Binding var activeTab: SegmentedTab
    let namespace: Namespace.ID
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(tabs, id: \.rawValue) { tab in
                Text(tab.rawValue)
                    .font(Font.pretendardSemiBold14)
                    .foregroundStyle(activeTab == tab ? .tcGray10 : .tcGray05)
                    .animation(.snappy, value: activeTab)
                    .frame(maxWidth: .infinity, maxHeight: 44)
                    .contentShape(.rect)
                    .onTapGesture {
                        withAnimation(.interactiveSpring()) {
                            activeTab = tab
                        }
                    }
                    .background(alignment: .leading) {
                        if activeTab == tab {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(activeTab == tab ? .white  : .tcGray02)
                                .matchedGeometryEffect(id: "rect", in: namespace)
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(.tcGray02)
        }
    }
}


fileprivate enum SegmentedTab: String, CaseIterable {
    case reservation = "예약 일정"
    case history = "이전 내역"
}


#Preview {
    ReservationListView()
        .environmentObject(ReservationListViewModel())
}
