//
//  TempCustomCalendar.swift
//  ToucheeseMVP
//
//  Created by Healthy on 1/16/25.
//

import SwiftUI

struct CustomCalendarView<ViewModel: CalendarViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @ObservedObject var detailViewModel: ProductDetailViewModel
    
    @Binding var isCalendarPresented: Bool
    @Binding var selectedDate: Date?
    
    @State private var isTransitioning: Bool = false
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                /// 상단 달 정보를 표시하는 화면
                TopMonthView(viewModel: viewModel)
                    .padding(.bottom, 16)
                
                /// 날짜를 선택하는 화면
                DateView(viewModel: viewModel)
                
                DividerView()
                    .padding(.vertical, 8)
                
                /// 시간을 선택하는 화면
                TimeView(viewModel: viewModel)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                
                /// 예약 날짜를 선택하는 버튼
                FillBottomButton(isSelectable: viewModel.isConfirmable, title: "날짜 선택") {
                    selectedDate = viewModel.confirmSelect()
                    detailViewModel.selectedDate = selectedDate ?? Date()
                    isCalendarPresented = false
                }
                
                Color.clear.frame(height: 25)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 32)
    }
    
    /// 상단 달 정보를 표시하는 화면
    struct TopMonthView: View {
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            HStack {
                // 이전 달 버튼
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.selectPreviousMonth()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.tcPrimary06)
                        .padding(.leading, 8)
                }
                
                Spacer()
                
                // 현재 표시되는 날짜
                Text(viewModel.topMonthString)
                    .font(.pretendardSemiBold16)
                    .foregroundStyle(.tcGray10)
                
                Spacer()
                
                // 다음 달 버튼
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.selectNextMonth()
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.tcPrimary06)
                        .padding(.trailing, 8)
                }
            }
        }
    }
    
    /// 날짜를 선택하는 화면
    struct DateView: View {
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                // 요일 표시
                ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { weekday in
                    Text(weekday)
                        .frame(idealWidth: 50, idealHeight: 40)
                        .font(.pretendardMedium14)
                        .foregroundStyle(.tcGray10)
                }
                
                // 빈칸 표시
                ForEach(0..<viewModel.calendarMonth.firstWeekday - 1, id: \.self) { _ in
                    Text("")
                        .frame(idealWidth: 50, idealHeight: 40)
                }
                
                // 날짜 표시
                ForEach(viewModel.studioCalendarEntities, id: \.self) { studioCalendarEntity in
                    let date = studioCalendarEntity.dateType
                    let isSelectedDate = viewModel.isSelectedDate(date)
                    let isHoliday = !studioCalendarEntity.status
                    
                    Button {
                        Task {
                            await viewModel.selectDate(date: date)
                        }
                    } label: {
                        Text("\(studioCalendarEntity.presentingDate)")
                            .font(isSelectedDate ? .pretendardSemiBold14 : .pretendardMedium14)
                            .fontWeight(isSelectedDate ? .semibold : .medium)
                            .foregroundStyle(isSelectedDate ? Color.white : (isHoliday || date.isPast ? .tcGray04 : .tcGray06))
                            .frame(idealWidth: 50, idealHeight: 40)
                            .background(
                                Circle()
                                    .fill(
                                        (isHoliday && isSelectedDate) ? .tcPrimary06 : (isSelectedDate ? .tcYellow : .clear)
                                    )
                                    .frame(width: 38, height: 38)
                            )
                    }
                    .disabled(isHoliday || date.isPast)
                }
            }
        }
    }
    
    /// 시간을 선택하는 화면
    struct TimeView: View {
        @ObservedObject var viewModel: ViewModel
        
        var body: some View {
            VStack {
                LeadingTextView(text: "선택 가능한 시간대", font: .pretendardSemiBold18, textColor: .black)
                    .padding(.bottom, 20)
                
                if !viewModel.studioReservableTime.AM.isEmpty {
                    LeadingTextView(text: "오전", font: .pretendardMedium14, textColor: .tcGray09)
                        .padding(.bottom, 4)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                        ForEach(viewModel.studioReservableTime.AM, id: \.self) { reservableTimeSlot in
                            let dateTypeTime = reservableTimeSlot.toDate(dateFormat: .hourMinute) ?? Date()
                            let isSelectedTime = viewModel.isSelectedTime(dateTypeTime)
                            
                            Button {
                                Task {
                                    await viewModel.selectTime(date: dateTypeTime)
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(
                                        isSelectedTime ? Color.clear : Color.tcGray03,
                                        lineWidth: 1
                                    )
                                    .frame(height: 40)
                                    .frame(idealWidth: 101)
                                    .background {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(isSelectedTime ? Color.tcPrimary06 : Color.white)
                                            .overlay {
                                                Text(reservableTimeSlot)
                                                    .font(.pretendardMedium16)
                                                    .foregroundStyle(isSelectedTime ? Color.white : Color.tcGray10)
                                            }
                                    }
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
                
                if !viewModel.studioReservableTime.PM.isEmpty {
                    LeadingTextView(text: "오후", font: .pretendardMedium14, textColor: .tcGray09)
                        .padding(.bottom, 4)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                        ForEach(viewModel.studioReservableTime.PM, id: \.self) { reservableTimeSlot in
                            let dateTypeTime = reservableTimeSlot.toDate(dateFormat: .hourMinute) ?? Date()
                            let isSelectedTime = viewModel.isSelectedTime(dateTypeTime)
                            
                            Button {
                                Task {
                                    await viewModel.selectTime(date: dateTypeTime)
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(
                                        isSelectedTime ? Color.clear : Color.tcGray03,
                                        lineWidth: 1
                                    )
                                    .frame(height: 40)
                                    .frame(idealWidth: 101)
                                    .background {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(isSelectedTime ? Color.tcPrimary06 : Color.white)
                                            .overlay {
                                                Text(reservableTimeSlot)
                                                    .font(.pretendardMedium16)
                                                    .foregroundStyle(isSelectedTime ? Color.white : Color.tcGray10)
                                            }
                                    }
                            }
                        }
                    }
                }
            }
        }
    }
}
//
//#Preview {
//    TempCustomCalendarView(viewModel: MockCustomCalendarViewModel(studioID: 1),
//                           isCalendarPresented: .constant(true), selectedDate: .constant(Date()))
//}
