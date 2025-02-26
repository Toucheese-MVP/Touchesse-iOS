//
//  ReservationDetailView.swift
//  TOUCHEESE
//
//  Created by 김성민 on 12/8/24.
//

import SwiftUI

struct ReservationDetailView<ViewModel: ReservationDetailViewModelProtocol>: View {
    private let authManager = AuthenticationManager.shared
    @EnvironmentObject private var navigationManager: NavigationManager
    @ObservedObject var viewModel: ViewModel
    

    @State private var isShowingReservationCancelAlert = false
    @State private var isShowingReservationCancelCompleteAlert = false
    @State private var isPushingStudioDetailView = false
    
    let reservation: Reservation
    
    var body: some View {
        
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    // 예약 정보
                    ReservationInfoView(
                        studioName: reservation.studioName,
                        studioAddress: nil,
                        reservationStatus: ReservationStatus(title: reservation.status),
                        reservationDateString: reservation.createDate.toReservationDateType,
                        reservationTimeString: reservation.createTime
                    )
                    
                    DividerView(color: .tcGray01, height: 8)
                    
                    //TODO: 예약 return 값으로 option, price, personnel 받기
                    // 주문 상품
                    ReservationProductView(
                        studioName: reservation.studioName,
                        productName: reservation.productName,
                        productPriceString: "",
                        productOptions: [],
                        peopleCount: nil
                    )
                    
                    DividerView(color: .tcGray01, height: 8)
                    
                    //TODO: 예약자 정보에 phone 받을지 상의하기
                    // 예약자 정보
                    userInfoView(
                        userEmail: authManager.memberEmail ?? "",
                        userPhoneNumber: ""
                    )
                    
                    DividerView(color: .tcGray01, height: 8)
                    
                    // 결제 정보
//                    PayInfoView(
//                        productName: reservation.productName,
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
                            
                            navigationManager.appendPath(
                                viewType: .studioDetailView,
                                viewMaterial: StudioDetailViewMaterial(
                                    viewModel: StudioDetailViewModel(
                                        studio: nil,
                                        studioId: reservation.studioId
                                    )
                                )
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
                    navigationManager.pop(1)
                } label: {
                    NavigationBackButtonView()
                }
            })
            
            //TODO: 예약 취소 관련 view
            if isShowingReservationCancelAlert {
                CustomAlertView(
                    isPresented: $isShowingReservationCancelAlert,
                    alertType: .reservationCancel
                ) {
                    isShowingReservationCancelCompleteAlert.toggle()
                    
                    Task {
                        // 예약 취소
                        await viewModel.cancelReservation()
                        // 화면 이동
                        navigationManager.goFirstView()
                    }
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
                ForEach(ReservationStatus.allCases, id: \.self) { status in
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
                if !userPhoneNumber.isEmpty {
                    
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
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .background(.white)
    }
}
