//
//  ReservationDetailView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/8/24.
//

import SwiftUI

struct ReservationDetailView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var reservationListViewModel: ReservationListViewModel
    @StateObject var viewModel: ReservationDetailViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var isShowingReservationCancelAlert = false
    @State private var isShowingReservationCancelCompleteAlert = false
    @State private var isPushingStudioDetailView = false
    
    var body: some View {
        let reservation = viewModel.reservation
        let reservationDetail = viewModel.reservationDetail
        
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    // 예약 정보
                    ReservationInfoView(
                        studioName: reservation.studioName,
                        studioAddress: reservationDetail.studioAddress,
                        reservationStatus: ReservationStatus(rawValue: reservation.reservationStatus) ?? .waiting,
                        userName: reservationDetail.memberName,
                        reservationDateString: reservation.reservationDate.toReservationDateType,
                        reservationTimeString: reservation.reservationTimeString
                    )
                    
                    DividerView(color: .tcGray01, height: 8)
                    
                    // 주문 상품
                    ReservationProductView(
                        studioName: reservation.studioName,
                        productName: reservationDetail.productName,
                        productImageURL: reservationDetail.productImageURL,
                        productPriceString: reservationDetail.productPrice.moneyStringFormat,
                        productOptions: reservationDetail.parsedProductOptions,
                        addPeopleCount: reservationDetail.addPeopleCnt,
                        addPeoplePriceString: reservationDetail.addPeoplePrice.moneyStringFormat
                    )
                    
                    DividerView(color: .tcGray01, height: 8)
                    
                    // 예약자 정보
                    userInfoView(
                        userEmail: reservationDetail.memberEmail,
                        userPhoneNumber: reservationDetail.phoneNumber
                    )
                    
                    DividerView(color: .tcGray01, height: 8)
                    
                    // 결제 정보
                    PayInfoView(
                        productName: reservationDetail.productName,
                        productPrice: reservationDetail.productPrice.moneyStringFormat,
                        productOptions: reservationDetail.parsedProductOptions,
                        addPeopleCount: reservationDetail.addPeopleCnt,
                        addPeoplePriceString: reservationDetail.addPeoplePrice.moneyStringFormat,
                        totalPriceString: reservationDetail.totalPrice.moneyStringFormat,
                        addPeopleTotalPriceString: reservationDetail.addPeoplePrice.moneyStringFormat
                    )
                    
                    HStack(spacing: 10) {
                        FillBottomButton(
                            isSelectable: true,
                            title: "스튜디오 홈",
                            height: 48
                        ) {
                            navigationManager.appendPath(
                                viewType: .studioDetailView,
                                viewMaterial: StudioDetailViewMaterial(viewModel: StudioDetailViewModel(studio: viewModel.reservedStudio))
                            )
                        }
                        
                        if viewModel.isShowingReservationCancelButton() {
                            StrokeBottomButton(title: "예약 취소하기") {
                                withAnimation(.easeOut(duration: 0.15)) {
                                    isShowingReservationCancelAlert.toggle()
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 21)
                    .padding(.horizontal, 16)
                    
                    reservationStatusInfoView
                        .padding(.horizontal, 16)
                    
                    Color.clear
                        .frame(height: 50)
                }
            }
            .customNavigationBar(centerView: {
                Text("예약 내역")
                    .modifier(NavigationTitleModifier())
            }, leftView: {
                Button {
                    dismiss()
                } label: {
                    NavigationBackButtonView()
                }
            })
            
            if isShowingReservationCancelAlert {
                CustomAlertView(
                    isPresented: $isShowingReservationCancelAlert,
                    alertType: .reservationCancel
                ) {
                    isShowingReservationCancelCompleteAlert.toggle()
                    
                    Task {
                        await viewModel.cancelReservation(reservationID: reservation.id)
                        await reservationListViewModel.fetchReservations()
                        await reservationListViewModel.fetchPastReservations()
                    }
                }
            }
            
            if isShowingReservationCancelCompleteAlert {
                CustomAlertView(
                    isPresented: $isShowingReservationCancelCompleteAlert,
                    alertType: .reservationCancelComplete
                ) {
                    dismiss()
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    private var reservationStatusInfoView: some View {
        VStack {
            Text("※ 예약 상태는 아래와 같습니다.")
                .foregroundStyle(.tcBlue)
                .font(.pretendardSemiBold16)
            
            VStack(alignment: .leading, spacing: 20) {
                ForEach(ReservationStatus.allCases, id: \.rawValue) { status in
                    VStack(alignment: .leading, spacing: 10) {
                        ReservationStatusView(status)
                        
                        Text(status.description)
                            .font(.pretendardRegular(12))
                            .foregroundStyle(.tcGray06)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(6)
                    }
                }
            }
            .padding(.top, 24)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(.tcGray02)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.tcGray03, lineWidth: 0.92)
                }
        }
    }
    
    private func userInfoView(
        userEmail: String,
        userPhoneNumber: String
    ) -> some View {
        VStack {
            LeadingTextView(text: "주문자 정보")
                .padding(.bottom, 16)
            
            VStack(spacing: 8) {
                HStack {
                    Text("이메일")
                        .font(.pretendardRegular14)
                        .foregroundStyle(.tcGray06)
                    
                    Spacer()
                    
                    Text(userEmail)
                        .font(.pretendardSemiBold14)
                        .foregroundStyle(.tcGray09)
                }
                
                HStack {
                    Text("휴대폰")
                        .font(.pretendardRegular14)
                        .foregroundStyle(.tcGray06)
                    
                    Spacer()
                    
                    Text(userPhoneNumber)
                        .font(.pretendardSemiBold14)
                        .foregroundStyle(.tcGray09)
                }
            }
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .background(.white)
    }
}

#Preview {
    NavigationStack {
        ReservationDetailView(
            viewModel: ReservationDetailViewModel(
                reservation: Reservation.sample
            )
        )
        .environmentObject(NavigationManager())
    }
}
