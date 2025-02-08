//
//  ReservationConfirmView.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/7/24.
//

import SwiftUI
import Kingfisher

struct ReservationConfirmView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    private let authenticationManager = AuthenticationManager.shared
    @StateObject var tempReservationViewModel: TempReservationViewModel
    
    var body: some View {
        let studioName = tempReservationViewModel.studio.name
        let address = tempReservationViewModel.studioDetail.address
        let tempProductOptions = tempReservationViewModel.productOptions
        let productName = tempReservationViewModel.product.name
        let productPriceString = tempReservationViewModel.product.price.moneyStringFormat
        let totalPriceString = tempReservationViewModel.totalPrice.moneyStringFormat
        let reservationDateString = tempReservationViewModel.reservationDate.toString(format: .reservationInfoDay)
        let reservationTimeString = tempReservationViewModel.reservationDate.toString(format: .reservationInfoTime)
        let addPeopleCount = tempReservationViewModel.addPeopleCount
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                // 예약 정보 뷰
                ReservationInfoView(
                    studioName: studioName,
                    studioAddress: address,
                    reservationStatus: .waiting,
                    reservationDateString: reservationDateString,
                    reservationTimeString: reservationTimeString
                )
                .padding(.bottom, 8)
                
                // 상품 정보 뷰
                ReservationProductView(
                    studioName: studioName,
                    productName: productName,
                    productPriceString: productPriceString,
                    productOptions: tempProductOptions,
                    peopleCount: addPeopleCount
                )
                
                DividerView(color: .tcGray01, height: 8)
                
                // 주문자 정보 입력 뷰
                UserInfoInputView(
                    userPhone: $tempReservationViewModel.userPhone,
                    isPhoneLength: tempReservationViewModel.isPhoneLength
                )
                
                // 주문자 정보 입력 뷰
                DividerView(color: .tcGray01, height: 8)
                
                //TODO: 수정하기
                // 결제 정보 뷰
                PayInfoView(
                    productName: productName,
                    productPrice: productPriceString,
                    productOptions: tempProductOptions,
                    addPeopleCount: addPeopleCount,
                    addPeoplePriceString: /*addPeoplePrice?.moneyStringFormat ??*/ "0원",
                    totalPriceString: totalPriceString,
                    addPeopleTotalPriceString: /*addpeopleTotalPriceString*/ ""
                )
                .padding(.bottom, 31)
                
                FillBottomButton(isSelectable: tempReservationViewModel.isBottomButtonSelectable, title: "예약하기") {
                    if !tempReservationViewModel.isReserving {
                        tempReservationViewModel.setIsReserving()
                        
                        Task {
                            let result = await tempReservationViewModel.postInstantReservation()
//
//                            // MARK: - TODO: 응답 코드에 따라 에러 뷰로 전환해야 함
//                            if reservationViewModel.reservationResponseData?.statusCode == 200 {
//                                await reservationListViewModel.fetchReservations()
//                                navigationManager.appendPath(viewType: .reservationCompleteView, viewMaterial: nil)
//                            } else {
//                                navigationManager.goFirstView()
//                            }
                            
                            if result {
                                navigationManager.appendPath(viewType: .reservationCompleteView, viewMaterial: nil)
                            } else {
                                print("fail")
                            }
                            
                        }
                    }
                }
                .padding(.horizontal, 16)
                
                Color.clear.frame(height: 25)
            }
        }
        .onAppear(perform : UIApplication.shared.hideKeyboard)
        .customNavigationBar(
            centerView: {
                Text("주문/예약")
                .modifier(NavigationTitleModifier())
            },
            leftView: {
            Button {
                navigationManager.pop(1)
            } label: {
                NavigationBackButtonView()
            }
        })
    }
}

struct ReservationProductView: View {
    let studioName: String
    let productName: String
    let productPriceString: String
    let productOptions: [OptionEntity]
    let peopleCount: Int?
    
    var body: some View {
        VStack {
            VStack {
                LeadingTextView(text: "주문 상품")
                    .padding(.bottom, 16)
                
                HStack {
                    VStack {
                        HStack {
                            Text(productName)
                                .font(.pretendardSemiBold14)
                                .foregroundStyle(.tcGray08)
                            
                            Spacer()
                            
                            Text(productPriceString)
                                .font(.pretendardBold13)
                                .foregroundStyle(.tcGray08)
                        }
                        .padding(.bottom, 4)
                        
                        if let peopleCount {
                            HStack {
                                Text("예약인원")
                                    .font(.pretendardRegular14)
                                Spacer()
                                Text("\(peopleCount)명")
                                    .font(.pretendardRegular14)
                            }
                            .foregroundStyle(.tcGray08)
                        }
                        
                        VStack(spacing: 0) {
                            ForEach(productOptions.indices, id: \.self) { index in
                                HStack {
                                    Text("ㄴ")
                                        .font(.pretendardRegular14)
                                        .padding(.trailing, 2)
                                    
                                    Text("\(productOptions[index].name)")
                                        .font(.pretendardRegular14)
                                    
                                    Spacer()
                                    
                                    Text("+\(productOptions[index].price.moneyStringFormat)")
                                        .font(.pretendardMedium12)
                                }
                                .frame(height: 18)
                                .foregroundStyle(.tcGray05)
                            }
                        }
                    }
                }
                .padding(16)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(.tcGray03, lineWidth: 1)
                }
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 16)
        }
        .background(.white)
    }
}

fileprivate struct UserInfoInputView: View {
    @Binding var userPhone: String
    
    @FocusState private var focusedField: FocusedField?

    var isPhoneLength: Bool
    
    private var isUserPhoneCorrect: Bool {
        if userPhone.isEmpty {
            return true
        }
        if userPhone.allSatisfy({ $0.isNumber }) {
            return true
        }
        return false
    }
    
    var body: some View {
        VStack {
            LeadingTextView(text: "주문자 정보")
                .padding(.bottom, 16)
            
            VStack {
                HStack(spacing: 0) {
                    Text("휴대폰")
                        .font(.pretendardMedium14)
                        .foregroundStyle(.tcGray07)
                        .padding(.trailing, 2)
                    
                    Text("*")
                        .font(.pretendardSemiBold14)
                        .foregroundStyle(.tcTempError)
                    
                    Spacer()
                    
                    TextFieldView(
                        inputValue: $userPhone,
                        placeHolder: "전화번호를 입력해주세요.",
                        isError: !isUserPhoneCorrect,
                        keyboardType: .numberPad
                    )
                    .focused($focusedField, equals: .phoneNumber)
                }
                
                if !userPhone.isEmpty && !isPhoneLength {
                    HStack {
                        Spacer()
                        
                        LeadingTextView(
                            text: "올바른 전화번호를 입력해주세요.",
                            font: .pretendardRegular14,
                            textColor: .tcTempError
                        )
                        .frame(width: 253)
                    }
                }
            }
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .onChange(of: userPhone) { newValue in
            userPhone = newValue.filter { $0.isNumber }
        }
    }
}

extension UserInfoInputView {
    enum FocusedField: Hashable {
        case phoneNumber
    }
}

struct PayInfoView: View {
    let productName: String
    let productPrice: String
    let productOptions: [OptionEntity]
    let addPeopleCount: Int
    let addPeoplePriceString: String
    let totalPriceString: String
    let addPeopleTotalPriceString: String

    var body: some View {
        VStack(spacing: 0) {
            LeadingTextView(
                text: "결제 정보",
                font: .pretendardSemiBold18,
                textColor: .tcGray10
            )
            .padding(.bottom, 16)
            
            HStack {
                Text(productName)
                    .font(.pretendardSemiBold16)
                    .foregroundStyle(.tcGray10)
                
                Spacer()
                
                Text(productPrice)
                    .font(.pretendardBold(16))
                    .foregroundStyle(.tcGray10)
            }
            .padding(.bottom, 8)
            
            if addPeopleCount > 1 {
                HStack {
                    Text("예약인원")
                        .font(.pretendardRegular14)
                    Spacer()
                    Text("\(addPeopleCount)명")
                        .font(.pretendardRegular14)
                }
                .frame(height: 18)
                .foregroundStyle(.tcGray10)
                .padding(.bottom, 12)
            }
            
            VStack {
                ForEach(productOptions.indices, id: \.self) { index in
                    HStack {
                        Text("ㄴ")
                            .font(.pretendardRegular14)
                            .padding(.trailing, 2)
                        
                        Text("\(productOptions[index].name)")
                            .font(.pretendardRegular14)
                        
                        Spacer()
                        
                        Text("\(productOptions[index].price.moneyStringFormat)")
                            .font(.pretendardMedium16)
                    }
                    .frame(height: 18)
                    .foregroundStyle(.tcGray05)
                    .padding(.bottom, 2)
                }
            }
            .padding(.leading, 16)
            .padding(.bottom, addPeopleCount > 0 ? 16 : 14)
            
            HStack {
                Text("총 결제 금액")
                    .font(.pretendardSemiBold18)
                    .foregroundStyle(.tcGray10)
                
                Spacer()
                
                Text(totalPriceString)
                    .font(.pretendardBold18)
                    .foregroundStyle(.tcGray10)
            }
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .background(.white)
    }
}
