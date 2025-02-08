//
//  ReservationDetailView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/8/24.
//

import SwiftUI

struct ReservationDetailView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
//    @EnvironmentObject private var reservationListViewModel: ReservationListViewModel
//    @StateObject var viewModel: ReservationDetailViewModel
    @StateObject var tempViewModel: TempReservationDetailViewModel
    
    @State private var isShowingReservationCancelAlert = false
    @State private var isShowingReservationCancelCompleteAlert = false
    @State private var isPushingStudioDetailView = false
    
    var body: some View {
//        let reservation = viewModel.reservation
//        let reservationDetail = viewModel.reservationDetail
        
        let tempReservation = tempViewModel.reservation
        let tempReservationDetail = tempViewModel.reservationDetail
        
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    // 예약 정보
                    ReservationInfoView(
                        studioName: tempReservation.studioName,
                        studioAddress: tempReservationDetail.studioAddress,
                        reservationStatus: ReservationStatus(rawValue: tempReservation.status) ?? .waiting,
                        userName: tempReservationDetail.memberName,
                        reservationDateString: tempReservation.createDate.toReservationDateType,
                        reservationTimeString: tempReservation.createTime
                    )
                    
                    DividerView(color: .tcGray01, height: 8)
                    
                    // 주문 상품
                    ReservationProductView(
                        studioName: tempReservation.studioName,
                        productName: tempReservationDetail.productName,
//                        productImageURL: reservationDetail.productImageURL,
                        //TODO: detail viewmodel 고치기
                        productPriceString: "",
                        //TODO: detail viewmodel 고치기
                        productOptions: [],
                        peopleCount: 1
//                        addPeopleCount: reservationDetail.addPeopleCnt,
//                        addPeoplePriceString: reservationDetail.addPeoplePrice.moneyStringFormat
                    )
                    
                    DividerView(color: .tcGray01, height: 8)
                    
                    // 예약자 정보
//                    userInfoView(
//                        userEmail: reservationDetail.memberEmail,
//                        userPhoneNumber: reservationDetail.phoneNumber
//                    )
                    
                    DividerView(color: .tcGray01, height: 8)
                    
                    // 결제 정보
//                    PayInfoView(
//                        productName: reservationDetail.productName,
//                        productPrice: reservationDetail.productPrice.moneyStringFormat,
//                        //TODO: 고치기
//                        productOptions: [],
//                        addPeopleCount: reservationDetail.addPeopleCnt,
//                        addPeoplePriceString: reservationDetail.addPeoplePrice.moneyStringFormat,
//                        totalPriceString: reservationDetail.totalPrice.moneyStringFormat,
//                        addPeopleTotalPriceString: reservationDetail.addPeoplePrice.moneyStringFormat
//                    )
                    
                    HStack(spacing: 10) {
                        FillBottomButton(
                            isSelectable: true,
                            title: "스튜디오 홈",
                            height: 48
                        ) {
//                            navigationManager.appendPath(
//                                viewType: .studioDetailView,
//                                // TODO: 임시 스튜디오 정보 유저가 선택한 스튜디오 정보로 변경해야 함
//                                viewMaterial: StudioDetailViewMaterial(viewModel: StudioDetailViewModel(studio: viewModel.reservedStudio, tempStudioData: TempStudio.sample))
//                            )
                        }
                        
                        if tempViewModel.isShowingReservationCancelButton() {
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
                    navigationManager.pop(1)
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
//                        await tempViewModel.cancelReservation(reservationID: tempReservation.id)
//                        await reservationListViewModel.fetchReservations()
//                        await reservationListViewModel.fetchPastReservations()
                    }
                }
            }
            
            if isShowingReservationCancelCompleteAlert {
                CustomAlertView(
                    isPresented: $isShowingReservationCancelCompleteAlert,
                    alertType: .reservationCancelComplete
                ) {
                    navigationManager.pop(1)
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

//#Preview {
//    NavigationStack {
//        ReservationDetailView(
//            viewModel: ReservationDetailViewModel(
//                reservation: Reservation.sample
//            )
//        )
//        .environmentObject(NavigationManager())
//    }
//}
