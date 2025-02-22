//
//  ReservationListView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/7/24.
//

import SwiftUI

struct ReservationListView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject var viewModel: ReservationListViewModel
    
    @State private var isShowingLogInView = false
    
    private let authManager = AuthenticationManager.shared
    
    var body: some View {
        ZStack {
            if authManager.authStatus == .notAuthenticated {
                CustomEmptyView(viewType: .requiredLogIn(buttonText: "로그인 하기") {
                    isShowingLogInView.toggle()
                })
            } else if viewModel.reservationList.isEmpty {
                CustomEmptyView(viewType: .reservation)
            } else {
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        Color.clear
                            .frame(height: 20)
                        
                        LazyVStack(spacing: 8) {
                            ForEach(viewModel.reservationList, id:\.self) { reservation in
                                Button {
                                    navigationManager.appendPath(
                                        viewType: .reservationDetailView,
                                        viewMaterial: ReservationDetailViewMaterial(
                                            viewModel: ReservationDetailViewModel(reservation: reservation), reservation: reservation)
                                    )
                                } label: {
                                    ReservationRow(reservation: reservation)
                                }
                                .onAppear {
                                    if reservation == viewModel.reservationList.last {
                                        Task {
                                            await viewModel.getReservationList()
                                        }
                                    }
                                }
                            }
                        }

                    }
                    .refreshable {
                        Task {
                            await viewModel.refreshAction()
                        }
                    }
                    .animation(.easeInOut, value: viewModel.reservationList)
                }
                .padding(.horizontal)
            }
        }
        .task {
            await viewModel.getReservationList()
        }
        .fullScreenCover(isPresented: $isShowingLogInView, onDismiss: {
            Task {
                await viewModel.refreshAction()
            }
        }) {
            LoginView(TviewModel: LogInViewModel(),
                      isPresented: $isShowingLogInView)
        }
        .customNavigationBar {
            Text("예약 내역")
                .modifier(NavigationTitleModifier())
        }
    }
    
}

// 혹시 몰라서 남겨두는 레거시 코드

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
