//
//  MyHoursScreen.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 27/11/2024.
//

import Foundation
import SwiftUI

struct AvailabilityScreen: View {
    @StateObject private var viewModel = AvailabilityViewModel()
    @State private var isShowingModal = false // Show modal to change availability
    
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    
    var body: some View {
        VStack {
            Header()
            
            Text("My working hours")
                .padding(.top)
                .font(.primary(size: 20))
                .foregroundColor(.primaryText)
            
            VStack(spacing: 20) {
                // month Navigation
                HStack {
                    Button(action: {
                        viewModel.previousMonth()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(AppColors.secondary)
                            .padding()
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text(viewModel.currentMonth)
                            .font(.secondary(size: 17))
                            .foregroundColor(.primaryText)
                        
                        Text("\(String(viewModel.currentYear))")
                            .font(.secondary(size: 15))
                            .foregroundColor(.secondaryText)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.nextMonth()
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(AppColors.secondary)
                            .padding()
                    }
                }
                
                // weekdays
                HStack {
                    ForEach(viewModel.calendarService.weekdaySymbols(), id: \.self) { weekday in
                        Text(weekday)
                            .font(.secondary(size: 12))
                            .foregroundColor(.secondaryText)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // calendar grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                    ForEach(viewModel.daysInGrid, id: \.self) { date in
                        if let date = date {
                            CalendarDayView(
                                day: Calendar.current.component(.day, from: date),
                                isSelected: viewModel.calendarService.isSameDate(date, viewModel.selectedDate),
                                availability: viewModel.availabilityData[date]
                            ) {
                                viewModel.selectDate(date)
                            }
                        } else {
                            CalendarDayView(
                                day: nil,
                                isSelected: false,
                                availability: nil
                            ) {}
                        }
                    }
                }
            }
            .padding()
            
            // bottom section for current day availability
            VStack {
                Text("\(viewModel.formattedSelectedDate)")
                    .font(.secondary(size: 17))
                    .foregroundColor(AppColors.secondary)
                    .padding(.top, 10)
                
                HStack {
                    if let availability = viewModel.selectedDayAvailability {
                        Circle()
                            .fill(availabilityDotColor(for: availability))
                            .frame(width: 12, height: 12)
                        Text(availability.timeRange)
                            .font(.secondary(size: 15))
                            .foregroundColor(.secondaryText)
                    } else {
                        Circle()
                            .fill(.green)
                            .frame(width: 12, height: 12)
                        Text("Available Entire Day")
                            .font(.secondary(size: 15))
                            .foregroundColor(.secondaryText)
                    }
                    Spacer()
                    Button(action: {
                        isShowingModal = true
                    }) {
                        Image(systemName: "calendar")
                            .foregroundColor(AppColors.secondary)
                            .padding(5)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                .padding()
            }
            
            Spacer()
        }
        .background(Color(UIColor.systemGray6).ignoresSafeArea())
        .onAppear {
            viewModel.loadInitialData()
        }
        .overlay(
           VStack {
               if showToast {
                   ToastNotification(message: toastMessage)
                       .padding(.top, 50)
               }
           }
        )
        .sheet(isPresented: $isShowingModal) {
            AvailabilityModal(
                isShowingModal: $isShowingModal,
                viewModel: viewModel
            ){ message in
                showToastWithMessage(message)
            }
        }
    }
    
    private func showToastWithMessage(_ message: String) {
        toastMessage = message
        showToast = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showToast = false
            }
        }
    }
}

struct CalendarDayView: View {
    let day: Int?
    let isSelected: Bool
    let availability: Availability?
    let onSelect: () -> Void
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(isSelected ? AppColors.secondary : Color.clear)
                    .frame(width: 36, height: 36)
                
                if let day = day {
                    Text("\(day)")
                        .foregroundColor(isSelected ? .white : .primaryText)
                        .font(.secondary(size: 17))
                        .frame(width: 36, height: 36)
                        .onTapGesture {
                            onSelect()
                        }
                    
                }
            }
            
            // render availability dot only if the day exists
            if day != nil {
                if let availability = availability {
                    Circle()
                        .fill(availabilityDotColor(for: availability))
                        .frame(width: 6, height: 6)
                } else {
                    Circle()
                        .fill(.green)
                        .frame(width: 6, height: 6)
                }
            }
        }
    }
}

#Preview {
    AvailabilityScreen()
}
