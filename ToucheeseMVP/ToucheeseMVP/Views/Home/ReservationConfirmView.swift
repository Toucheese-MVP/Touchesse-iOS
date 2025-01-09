//
//  ReservationConfirmView.swift
//  TOUCHEESE
//
//  Created by Healthy on 12/7/24.
//

import SwiftUI
import Kingfisher

struct ReservationConfirmView: View {
    // MARK: - RealDatas
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var reservationListViewModel: ReservationListViewModel
    @Environment(\.dismiss) private var dismiss
    @StateObject var reservationViewModel: ReservationViewModel
    
    var body: some View {
        let studioName = reservationViewModel.studio.name
        let address = reservationViewModel.studioDetail.address
        let userName = reservationViewModel.userName ?? ""
        let productOptions = reservationViewModel.productOptions
        let productName = reservationViewModel.product.name
        let productPriceString = reservationViewModel.product.price.moneyStringFormat
        let totalPriceString = reservationViewModel.totalPrice.moneyStringFormat
        let reservationDateString = reservationViewModel.reservationDate.toString(format: .reservationInfoDay)
        let reservationTimeString = reservationViewModel.reservationDate.toString(format: .reservationInfoTime)
        let addPeopleCount = reservationViewModel.addPeopleCount
        let addPeoplePrice = reservationViewModel.productDetail.addPeoplePrice
        let addpeopleTotalPriceString = reservationViewModel.addpeopleTotalPriceString
        let productImageURL = reservationViewModel.product.imageURL
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                // 예약 정보 뷰
                ReservationInfoView(
                    studioName: studioName,
                    studioAddress: address,
                    reservationStatus: .waiting,
                    userName: userName,
                    reservationDateString: reservationDateString,
                    reservationTimeString: reservationTimeString
                )
                .padding(.bottom, 8)
                
                // 상품 정보 뷰
                ReservationProductView(
                    studioName: studioName,
                    productName: productName,
                    productImageURL: productImageURL,
                    productPriceString: productPriceString,
                    productOptions: productOptions,
                    addPeopleCount: addPeopleCount,
                    addPeoplePriceString: addPeoplePrice?.moneyStringFormat ?? "0원"
                )
                
                DividerView(color: .tcGray01, height: 8)
                
                // 주문자 정보 입력 뷰
                UserInfoInputView(
                    userEmail: $reservationViewModel.userEmail,
                    userPhone: $reservationViewModel.userPhone,
                    isEmailFormat: reservationViewModel.isEmailFormat,
                    isPhoneLength: reservationViewModel.isPhoneLength
                )
                
                // 주문자 정보 입력 뷰
                DividerView(color: .tcGray01, height: 8)
                
                // 결제 정보 뷰
                PayInfoView(
                    productName: productName,
                    productPrice: productPriceString,
                    productOptions: productOptions,
                    addPeopleCount: addPeopleCount,
                    addPeoplePriceString: addPeoplePrice?.moneyStringFormat ?? "0원",
                    totalPriceString: totalPriceString,
                    addPeopleTotalPriceString: addpeopleTotalPriceString
                )
                .padding(.bottom, 31)
                
                FillBottomButton(isSelectable: reservationViewModel.isBottomButtonSelectable, title: "예약하기") {
                    if !reservationViewModel.isReserving {
                        reservationViewModel.setIsReserving()
                        
                        Task {
                            await reservationViewModel.requestStudioReservation()
                            
                            // MARK: - TODO: 응답 코드에 따라 에러 뷰로 전환해야 함
                            if reservationViewModel.reservationResponseData?.statusCode == 200 {
                                await reservationListViewModel.fetchReservations()
                                navigationManager.appendPath(viewType: .reservationCompleteView, viewMaterial: nil)
                            } else {
                                navigationManager.goFirstView()
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
                Text(
                    "주문/예약"
                )
                .modifier(
                    NavigationTitleModifier()
                )
            },
            leftView: {
            Button {
                dismiss()
            } label: {
                NavigationBackButtonView()
            }
        })
    }
}

struct ReservationProductView: View {
    let studioName: String
    let productName: String
    let productImageURL: URL
    let productPriceString: String
    let productOptions: [ProductOption]
    let addPeopleCount: Int
    let addPeoplePriceString: String
    
    var body: some View {
        VStack {
            VStack {
                LeadingTextView(text: "주문 상품")
                    .padding(.bottom, 16)
                
                HStack {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(.tcGray03, lineWidth: 1)
                        .frame(width: 62, height: 62)
                        .background {
                            KFImage(productImageURL)
                                .placeholder { ProgressView() }
                                .fade(duration: 0.25)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 62, height: 62)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding(.trailing, 12)
                    
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
                            
                            if addPeopleCount > 0 {
                                HStack {
                                    Text("ㄴ")
                                        .font(.pretendardRegular14)
                                        .padding(.trailing, 2)
                                    
                                    Text("추가 인원")
                                        .font(.pretendardRegular14)
                                    
                                    Spacer()
                                    
                                    Text("\(addPeopleCount)인")
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
    @Binding var userEmail: String
    @Binding var userPhone: String
    
    @FocusState private var focusedField: FocusedField?
    
    var isEmailFormat: Bool
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
                    Text("이메일")
                        .font(.pretendardMedium14)
                        .foregroundStyle(.tcGray07)
                        .padding(.trailing, 2)
                    
                    Text("*")
                        .font(.pretendardSemiBold14)
                        .foregroundStyle(.tcTempError)
                    
                    Spacer()
                    
                    TextFieldView(
                        inputValue: $userEmail,
                        placeHolder: "이메일을 입력해주세요.",
                        keyboardType: .emailAddress,
                        submitAction: { focusedField = .phoneNumber }
                    )
                    .focused($focusedField, equals: .email)
                }
                
                if !userEmail.isEmpty && !isEmailFormat {
                    HStack {
                        Spacer()
                        
                        LeadingTextView(
                            text: "이메일 형식에 맞게 입력해주세요.",
                            font: .pretendardRegular14,
                            textColor: .tcTempError
                        )
                        .frame(width: 253)
                    }
                }
            }
            .padding(.bottom, 12)
            
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
        case email
        case phoneNumber
    }
}

struct PayInfoView: View {
    let productName: String
    let productPrice: String
    let productOptions: [ProductOption]
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
                
                if addPeopleCount > 0 {
                    HStack {
                        Text("ㄴ")
                            .font(.pretendardRegular14)
                            .padding(.trailing, 2)
                        
                        Text("추가 인원 \(addPeopleCount)명")
                            .font(.pretendardRegular14)
                        
                        Spacer()
                        
                        Text(addPeopleTotalPriceString)
                            .font(.pretendardMedium16)
                    }
                    .frame(height: 18)
                    .foregroundStyle(.tcGray05)
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

#Preview {
    NavigationStack {
        ReservationConfirmView(reservationViewModel: ReservationViewModel(studio: Studio.sample, studioDetail: StudioDetail.sample, product: Product.sample1, productDetail: ProductDetail.sample1, productOptions: [ProductOption.sample1, ProductOption.sample2], reservationDate: Date(), totalPrice: 130000, addPeopleCount: 3))
            .environmentObject(NavigationManager())
    }
}
