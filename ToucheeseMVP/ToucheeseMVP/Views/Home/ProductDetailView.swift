//
//  ProductDetailView.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/26/24.
//

import SwiftUI
import Kingfisher

struct ProductDetailView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @StateObject var productDetailViewModel: ProductDetailViewModel
    
    private let authManager = AuthenticationManager.shared
    
    @State private var displayDate: Date?
    
    // 캘린더 시트 트리거
    @State private var isCalendarPresented = false
    @State private var isShowingLoginView: Bool = false
    
    var body: some View {
        let product = productDetailViewModel.product
        let studioId = productDetailViewModel.studio.id
        let isBottomButtonSelectable = productDetailViewModel.isReservationDate
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                // 상품 정보 뷰(상품 사진, 이름, 설명)
                infoView(product: product)
                
                // 상품 옵션 선택 뷰
                optionView
                
                // 촬영 날짜 예약 뷰
                reservationView
                
                Spacer()
                
                FillBottomButton(isSelectable: isBottomButtonSelectable, title: "선택 상품 주문 \(productDetailViewModel.totalPrice.moneyStringFormat)") {
                    
                    if authManager.authStatus == .authenticated {
                        navigationManager
                            .appendPath(
                                viewType:
                                        .reservationConfirmView(
                                            studio: productDetailViewModel.studio,
                                            studioDetail: productDetailViewModel.studioDetail,
                                            product: productDetailViewModel.product,
                                            productDetail: productDetailViewModel.productDetail,
                                            productOption: productDetailViewModel.selectedProductOptionArray,
                                            reservationDate: productDetailViewModel.reservationDate ?? Date(),
                                            totalPrice: productDetailViewModel.totalPrice,
                                            addPeopleCount: productDetailViewModel.addPeopleCount
                                        ),
                                viewMaterial: nil
                            )
                    } else {
                        isShowingLoginView
                            .toggle()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                
                Color.clear.frame(height: 25)
            }
        }
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
                    navigationManager.pop(1)
                } label: {
                    NavigationBackButtonView()
                }
            })
        .sheet(isPresented: $isCalendarPresented) {
            // 예약할 날짜를 선택하는 캘린더 뷰
            CustomCalendarView(
                viewModel: CustomCalendarViewModel(
                    studioID: studioId,
                    preSelectedDate: displayDate
                ),
                detailViewModel: productDetailViewModel,
                isCalendarPresented: $isCalendarPresented,
                selectedDate: $displayDate
            )
            .presentationDetents([.fraction(0.9)])
            .presentationDragIndicator(.hidden)
            
        }
        .fullScreenCover(isPresented: $isShowingLoginView, content: {
            LoginView(TviewModel: LogInViewModel(),
                      isPresented: $isShowingLoginView)
        })
    }
    
    
}

extension ProductDetailView {
    
    @ViewBuilder
    private func infoView(product: ProductEntity) -> some View {
        // 이미지 프레임 값
        let imageFrame: CGFloat = 144
        
        VStack {
            VStack {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(.tcGray03, lineWidth: 1)
                    .frame(width: imageFrame, height: imageFrame)
                    .background {
                        if let imageURL = URL(string: product.productImage) {
                            KFImage(imageURL)
                                .placeholder { ProgressView() }
                                .resizable()
                                .cancelOnDisappear(true)
                                .fade(duration: 0.25)
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding(.bottom, 12)
                
                Text(product.name)
                    .font(.pretendardSemiBold22)
                    .foregroundStyle(.tcGray10)
                    .padding(.bottom, 10)
                
                Text(product.description)
                    .multilineTextAlignment(.center)
                    .font(.pretendardRegular13)
                    .foregroundStyle(.tcGray08)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(.tcGray02, lineWidth: 1)
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(.white)
                            }
                    }
                
                HStack(alignment: .bottom) {
                    Text("가격")
                        .font(.pretendardMedium16)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(product.standard)인 기준")
                            .font(.pretendardMedium12)
                        Text("\(product.price)원")
                            .font(.pretendardBold(16))
                    }
                }
                .padding(.vertical, 16)
                HStack {
                    Text("인원")
                    Spacer()
                    
                    Button {
                        productDetailViewModel.decreaseAddPeopleCount()
                    } label: {
                        Image(.tcMinusButton)
                    }
                    .frame(width: 36, height: 36)
                    
                    Text("\(productDetailViewModel.addPeopleCount)")
                        .frame(minWidth: 40)
                        .padding(.horizontal, 0)
                    
                    Button {
                        productDetailViewModel.increaseAddPeopleCount()
                    } label: {
                        Image(.tcPlusButton)
                    }
                    .frame(width: 36, height: 36)
                    
                }
            }
            .padding(.vertical, 26)
            .padding(.horizontal, 29)
        }
        .frame(minHeight: 274)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(.tcGray02, lineWidth: 1)
                }
        )
        .padding(16)
    }
    
    private var optionView: some View {
        let productOptions = productDetailViewModel.productDetail.addOptions
        
        return VStack {
            if !productOptions.isEmpty {
                VStack {
                    LeadingTextView(text: "추가 구매", font: .pretendardSemiBold18, textColor: .tcGray10)
                        .padding(.bottom, 10)
                    
                    VStack(spacing: 10) {
                        ForEach(productOptions, id: \.self) { option in
                            OptionItemView(productOption: option, productDetailViewModel: productDetailViewModel)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 30)
                
                DividerView(horizontalPadding: 16, color: .tcGray02)
                
            }
        }
        .background(.white)
    }
    
    private var reservationView: some View {
        VStack {
            VStack {
                LeadingTextView(text: "촬영날짜", font: .pretendardSemiBold18, textColor: .tcGray10)
                    .padding(.bottom, 10)
                
                Button {
                    isCalendarPresented.toggle()
                } label: {
                    HStack {
                        if productDetailViewModel.reservationDate == nil {
                            Text("예약일자 및 시간 선택")
                                .font(.pretendardMedium16)
                                .foregroundStyle(.tcGray05)
                        } else {
                            Text("\(productDetailViewModel.reservationDate!.toString(format: .monthDayTime))")
                                .font(.pretendardMedium16)
                                .foregroundStyle(.tcGray09)
                        }
                        
                        Spacer()
                        
                        Image(.tcCalendar)
                            .frame(width: 24, height: 24)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background {
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundStyle(.tcGray02)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 30)
        }
        .background(.white)
    }
}

fileprivate struct OptionItemView: View {
    @State var isSelected: Bool = false
    let productOption: OptionEntity
    @ObservedObject var productDetailViewModel: ProductDetailViewModel
    
    var body: some View {
        HStack {
            Button {
                isSelected.toggle()
                productDetailViewModel.optionChanged(isSelected: isSelected, id: productOption.id)
            } label: {
                HStack(alignment: .top) {
                    Image(isSelected ? .tcCheckBoxFill : .tcCheckBox)
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 10)
                    
                    Group {
                        Text("\(productOption.name)")
                            .font(.pretendardRegular16)
                            .foregroundStyle(.tcGray10)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        Text("\(productOption.price.moneyStringFormat)")
                            .font(.pretendardMedium16)
                            .foregroundStyle(.tcGray10)
                    }
                    .padding(.top, 2)
                }
            }
        }
    }
}
