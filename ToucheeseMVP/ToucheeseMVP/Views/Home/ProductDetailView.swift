//
//  ProductDetailView.swift
//  TOUCHEESE
//
//  Created by Healthy on 11/26/24.
//

import SwiftUI
import Kingfisher

struct ProductDetailView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var productDetailViewModel: ProductDetailViewModel
    
    private let authManager = AuthenticationManager.shared
    
    // 캘린더 시트 트리거
    @State private var isCalendarPresented = false
    @State private var isShowingLoginView: Bool = false
    
    var body: some View {
        let product = productDetailViewModel.product
        let productDetail = productDetailViewModel.productDetail
        let addPeoplePriceString = productDetailViewModel.getAddPeoplePriceString()
        let basePeopleCnt = productDetail.basePeopleCnt ?? 1
        let isBottomButtonSelectable = productDetailViewModel.isReservationDate
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                // 상품 정보 뷰(상품 사진, 이름, 설명)
                infoView(product: product)
                
                // 상품 옵션 선택 뷰
                OptionView()
                
                // 상품 단체 옵션 선택 뷰
                GroupOptionView(
                    basePeopleCount: basePeopleCnt,
                    addPeoplePriceString: addPeoplePriceString
                )
                
                // 총 가격 뷰
                TotalPriceView()
                
                // 촬영 날짜 예약 뷰
                ReservationView(isCalendarPresented: $isCalendarPresented)
                
                Spacer()
                
                FillBottomButton(isSelectable: isBottomButtonSelectable, title: "선택 상품 주문 \(productDetailViewModel.totalPrice.moneyStringFormat)") {
                    
                    if authManager.authStatus == .authenticated {
                        navigationManager
                            .appendPath(
                                viewType: .reservationConfirmView,
                                viewMaterial: ReservationConfirmViewMaterial(
                                    viewModel: ReservationViewModel(
                                        studio: productDetailViewModel.studio,
                                        studioDetail: productDetailViewModel.studioDetail,
                                        product: productDetailViewModel.product,
                                        productDetail: productDetailViewModel.productDetail,
                                        productOptions: productDetailViewModel.selectedProductOptionArray,
                                        reservationDate: productDetailViewModel.reservationDate ?? Date(),
                                        totalPrice: productDetailViewModel.totalPrice,
                                        addPeopleCount: productDetailViewModel.addPeopleCount
                                    )
                                )
                            )
                    } else {
                        isShowingLoginView.toggle()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                
                Color.clear.frame(height: 25)
            }
        }
        .environmentObject(productDetailViewModel)
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
        .sheet(isPresented: $isCalendarPresented) {
            // 예약할 날짜를 선택하는 캘린더 뷰
            CalendarView(isCalendarPresented: $isCalendarPresented, displayTime: productDetailViewModel.selectedTime?.toString(format: .hourMinute) ?? "", displayDate: productDetailViewModel.selectedDate)
                .presentationDetents([.fraction(0.9)])
                .presentationDragIndicator(.hidden)
                .environmentObject(productDetailViewModel)
        }
        .fullScreenCover(isPresented: $isShowingLoginView, content: {
            LogInView(isPresented: $isShowingLoginView)
        })
    }
    
    @ViewBuilder
    private func infoView(product: Product) -> some View {
        // 이미지 프레임 값
        let imageFrame: CGFloat = 144
        
        VStack {
            VStack {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(.tcGray03, lineWidth: 1)
                    .frame(width: imageFrame, height: imageFrame)
                    .background {
                        KFImage(product.imageURL)
                            .placeholder { ProgressView() }
                            .resizable()
                            .cancelOnDisappear(true)
                            .fade(duration: 0.25)
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 8))
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
            }
            .padding(.vertical, 26)
            .padding(.horizontal, 29)
        }
        .frame(minHeight: 274)
        .frame(maxWidth: .infinity)
    }
}

fileprivate struct OptionView: View {
    @EnvironmentObject private var productDetailViewModel: ProductDetailViewModel
    
    var body: some View {
        let parsedProductOptions = productDetailViewModel.productDetail.parsedProductOptions
        
        if !parsedProductOptions.isEmpty {
            VStack {
                VStack {
                    LeadingTextView(text: "추가 구매", font: .pretendardSemiBold18, textColor: .tcGray10)
                        .padding(.bottom, 10)
                    
                    VStack(spacing: 10) {
                        ForEach(parsedProductOptions) { option in
                            OptionItemView(productOption: option)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 30)
                
                DividerView(horizontalPadding: 16, color: .tcGray02)
            }
            .background(.white)
        }
    }
}


fileprivate struct GroupOptionView: View {
    @EnvironmentObject private var productDetailViewModel: ProductDetailViewModel
    
    let basePeopleCount: Int
    let addPeoplePriceString: String
    
    var body: some View {
        if productDetailViewModel.productDetail.isGroup {
            VStack {
                VStack {
                    HStack {
                        Text("기준 인원")
                        
                        Spacer()
                        
                        Text("\(basePeopleCount)명")
                    }
                    .font(.pretendardSemiBold18)
                    .foregroundStyle(.tcGray10)
                    .padding(.bottom, 30)
                    
                    HStack {
                        Text("추가 인원 (\(addPeoplePriceString))")
                        
                        Spacer()
                        
                        Button {
                            productDetailViewModel.decreaseAddPeopleCount()
                        } label: {
                            Image(.tcMinusButton)
                        }
                        .frame(width: 36, height: 36)
                        
                        Text("\(productDetailViewModel.addPeopleCount)명")
                            .frame(minWidth: 40)
                            .padding(.horizontal, 0)
                        
                        Button {
                            productDetailViewModel.increaseAddPeopleCount()
                        } label: {
                            Image(.tcPlusButton)
                        }
                        .frame(width: 36, height: 36)
                    }
                    .font(.pretendardSemiBold18)
                    .foregroundStyle(.tcGray10)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 30)
                
                DividerView(horizontalPadding: 16, color: .tcGray02)
            }
            .background(.white)
        }
    }
}

fileprivate struct OptionItemView: View {
    @EnvironmentObject private var productDetailViewModel: ProductDetailViewModel
    @State var isSelected: Bool = false
    let productOption: ProductOption
    
    var body: some View {
        HStack {
            Button {
                isSelected.toggle()
                productDetailViewModel.optionChanged(isSelected: isSelected, id: productOption.id)
            } label: {
                HStack(alignment: .top) {
                    Image(isSelected ? .tcToggleOn : .tcToggleOff)
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

fileprivate struct TotalPriceView: View {
    @EnvironmentObject private var productDetailViewModel: ProductDetailViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("총 결제 금액")
                    .font(.pretendardSemiBold18)
                    .foregroundStyle(.tcGray10)
                
                Spacer()
                
                Text(productDetailViewModel.totalPrice.moneyStringFormat)
                    .font(.pretendardBold18)
                    .foregroundStyle(.tcGray10)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 30)
            
            DividerView(color: .tcGray02, height: 8)
        }
        .background(.white)
    }
}

fileprivate struct ReservationView: View {
    @Binding var isCalendarPresented: Bool
    @EnvironmentObject private var productDetailViewModel: ProductDetailViewModel
    
    var body: some View {
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
                            Text("예약 날짜: \(productDetailViewModel.reservationDate!.toString(format: .monthDayTime))")
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

fileprivate struct CalendarView: View {
    @EnvironmentObject private var productDetailViewModel: ProductDetailViewModel
    @Binding var isCalendarPresented: Bool
    
    @State var displayTime: String = ""
    @State var displayDate = Date()
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    CustomCalendar(displayDate: $displayDate, displayTime: $displayTime)
                    
                    DividerView()
                        .padding(.vertical, 8)
                    
                    VStack {
                        LeadingTextView(text: "선택 가능한 시간대", font: .pretendardSemiBold18, textColor: .black)
                        .padding(.bottom, 20)
                        
                        if !productDetailViewModel.businessHourAM.isEmpty {
                            LeadingTextView(text: "오전", font: .pretendardMedium14, textColor: .tcGray09)
                                .padding(.bottom, 4)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                                ForEach(productDetailViewModel.businessHourAM, id: \.self) { reservableTimeSlot in
                                    Button {
                                        displayTime = reservableTimeSlot.reservableTime
                                    } label: {
                                        RoundedRectangle(cornerRadius: 12)
                                            .strokeBorder(getStrokeBorderColor(reservableTimeSlot: reservableTimeSlot), lineWidth: 1)
                                            .frame(height: 40)
                                            .frame(idealWidth: 101)
                                            .background {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(getFillColor(reservableTimeSlot: reservableTimeSlot))
                                                    .overlay {
                                                        Text(reservableTimeSlot.reservableTime)
                                                            .font(.pretendardMedium16)
                                                            .foregroundStyle(getTextColor(reservableTimeSlot: reservableTimeSlot))
                                                    }
                                            }
                                    }
                                    .disabled(!reservableTimeSlot.isAvailable)
                                }
                            }
                            .padding(.bottom, 20)
                        }
                        
                        if !productDetailViewModel.businessHourPM.isEmpty {
                            LeadingTextView(text: "오후", font: .pretendardMedium14, textColor: .tcGray09)
                                .padding(.bottom, 4)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                                ForEach(productDetailViewModel.businessHourPM, id: \.self) { reservableTimeSlot in
                                    Button {
                                        displayTime = reservableTimeSlot.reservableTime
                                    } label: {
                                        RoundedRectangle(cornerRadius: 12)
                                            .strokeBorder(getStrokeBorderColor(reservableTimeSlot: reservableTimeSlot), lineWidth: 1)
                                            .frame(height: 40)
                                            .frame(idealWidth: 101)
                                            .background {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(getFillColor(reservableTimeSlot: reservableTimeSlot))
                                                    .overlay {
                                                        Text(reservableTimeSlot.reservableTime)
                                                            .font(.pretendardMedium16)
                                                            .foregroundStyle(getTextColor(reservableTimeSlot: reservableTimeSlot))
                                                    }
                                            }
                                    }
                                    .disabled(!reservableTimeSlot.isAvailable)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                    
                    Button {
                        productDetailViewModel.selectedTime = displayTime.toDate(dateFormat: .hourMinute)
                        productDetailViewModel.selectedDate = displayDate
                        isCalendarPresented = false
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(height: 48)
                            .foregroundStyle(displayTime == "" ? .tcGray03 : .tcPrimary06)
                            .overlay {
                                Text("날짜 선택")
                                    .font(.pretendardBold20)
                                    .foregroundStyle(displayTime == "" ?  .tcGray05 : .tcGray10)
                            }
                    }
                    .disabled(displayTime == "" ? true : false)
                    .padding(.horizontal, 20)
                    
                    Color.clear.frame(height: 25)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 32)
    }
    
    private func getStrokeBorderColor(reservableTimeSlot: ReservableTimeSlot) -> Color {
        if !reservableTimeSlot.isAvailable {
            return Color.clear
        } else if displayTime == reservableTimeSlot.reservableTime {
            return Color.clear
        } else {
            return Color.tcGray03
        }
    }
    
    private func getFillColor(reservableTimeSlot: ReservableTimeSlot) -> Color {
        if !reservableTimeSlot.isAvailable {
            return Color.tcGray02
        } else if displayTime == reservableTimeSlot.reservableTime {
            return Color.tcPrimary06
        } else {
            return Color.white
        }
    }
    
    private func getTextColor(reservableTimeSlot: ReservableTimeSlot) -> Color {
        if !reservableTimeSlot.isAvailable {
            return Color.tcGray05
        } else if displayTime == reservableTimeSlot.reservableTime {
            return Color.white
        } else {
            return Color.tcGray10
        }
    }
}

fileprivate struct CustomCalendar: View {
    @EnvironmentObject private var productDetailViewModel: ProductDetailViewModel
    
    // 캘린더 상단에 표시되는 기준 날짜
    @Binding var displayDate: Date
    @Binding var displayTime: String
    @State private var displayMonth = Date()
    
    // 현재 날짜의 정보를 가져오는 계산 속성
    private var calendar: Calendar { Calendar.current }
    
    var body: some View {
        VStack {
            HStack {
                // 이전 달 버튼
                Button {
                    displayMonth = calendar.date(byAdding: .month, value: -1, to: displayMonth) ?? Date()
                } label: {
                    Image(systemName: "chevron.left")
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.tcPrimary06)
                        .padding(.leading, 8)
                }
                
                Spacer()
                
                // 현재 표시되는 날짜
                Text("\(displayMonth.toString(format: .yearMonth))")
                    .font(.pretendardSemiBold16)
                    .foregroundStyle(.tcGray10)
                
                Spacer()
                
                // 다음 달 버튼
                Button {
                    displayMonth = calendar.date(byAdding: .month, value: +1, to: displayMonth) ?? Date()
                } label: {
                    Image(systemName: "chevron.right")
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.tcPrimary06)
                        .padding(.trailing, 8)
                }
            }
            .padding(.bottom, 16)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                // 요일 표시
                ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { weekday in
                    Text(weekday)
                        .frame(idealWidth: 50, idealHeight: 40)
                        .font(.pretendardMedium14)
                        .foregroundStyle(.tcGray10)
                }
                
                // 빈칸 표시
                ForEach(0..<displayMonth.firstWeekday - 1, id: \.self) { _ in
                    Text("")
                        .frame(idealWidth: 50, idealHeight: 40)
                }
                
                // 날짜 표시
                ForEach(displayMonth.daysInMonth, id: \.self) { date in
                    let isHoliday = date.isHoliday(holidays: productDetailViewModel.studioDetail.holidays)
                    
                    let isSelected = calendar.isDate(date, inSameDayAs: displayDate)
                    
                    Button {
                        displayDate = date
                        displayTime = ""
                        Task {
                            await productDetailViewModel.fetchReservableTime(date: displayDate)
                        }
                    } label: {
                        Text("\(date.dayNumber)")
                            .font(isSelected ? .pretendardSemiBold14 : .pretendardMedium14)
                            .fontWeight(isSelected ? .semibold : .medium)
                            .foregroundStyle(
                                isSelected ? Color.white : (isHoliday || date.isPast ? .tcGray04 : .tcGray06))
                            .frame(idealWidth: 50, idealHeight: 40)
                            .background(
                                Circle()
                                    .fill(
                                        (isHoliday && isSelected) ? .tcPrimary06 : (isSelected ? .tcYellow : .clear)
                                    )
                                    .frame(width: 38, height: 38)
                            )
                    }
                    .disabled(isHoliday || date.isPast)
                }
            }
        }
        .onAppear {
            displayMonth = productDetailViewModel.selectedDate
            
            Task {
                await productDetailViewModel.fetchReservableTime(date: displayDate)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(productDetailViewModel: ProductDetailViewModel(studio: Studio.sample, studioDetails: StudioDetail.sample, product: Product.sample1))
    }
}
