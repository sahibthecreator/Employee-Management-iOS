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
    @State private var isShowingModal = false // State to show/hide modal
    
    var body: some View {
        VStack {
            Header()
//            // Header Section
//            HeaderView(title: "MY WORKING HOURS") {
//                viewModel.goBack()
//            }

            // Calendar Section
            VStack(spacing: 20) {
                // Month and Year Navigation
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
                            .font(.headline)
                            .fontWeight(.bold)

                        Text("\(String(viewModel.currentYear))")
                            .foregroundColor(.gray)
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

                // Weekdays Row
                HStack {
                    ForEach(viewModel.weekdaySymbols, id: \.self) { weekday in
                        Text(weekday)
                            .font(.caption)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.gray)
                    }
                }

                // Calendar Grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                    ForEach(viewModel.daysInMonth, id: \.self) { day in
                        CalendarDayView(day: day, isSelected: viewModel.isSelected(day: day)) {
                            viewModel.selectDate(day)
                        }
                    }
                }
            }
            .padding()

            // Bottom Availability Section
            
                VStack {
                    Text("\(viewModel.formattedSelectedDate)")
                        .font(.headline)
                        .foregroundColor(AppColors.secondary)
                        .padding(.top, 10)

                    HStack {
                        if let availability = viewModel.selectedDayAvailability {
                            Circle()
                                .fill(.orange)
                                .frame(width: 12, height: 12)
                            Text(availability.timeRange)
                                .foregroundColor(.gray)
                        }
                        else {
                            Circle()
                                .fill(.green)
                                .frame(width: 12, height: 12)
                            Text("Available Entire Day")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Button(action: {
                            isShowingModal = true // Show the modal
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
        .sheet(isPresented: $isShowingModal) {
            AvailabilityModal(isShowingModal: $isShowingModal, viewModel: viewModel)
                .presentationBackground(.thinMaterial)
                .presentationDetents([.medium, .large, .fraction(0.8), .height(400)])
        }
    }
}

struct CalendarDayView: View {
    let day: Int?
    let isSelected: Bool
    let onSelect: () -> Void
    
   
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(isSelected ? AppColors.secondary : Color.clear)
                    .frame(width: 36, height: 36)
                
                Text(day != nil ? "\(day!)" : "")
                    .foregroundColor(isSelected ? .white : .black)
                    .frame(width: 36, height: 36)
                    .background(isSelected ? AppColors.secondary : Color.clear)
                    .clipShape(Circle())
                    .onTapGesture {
                        onSelect()
                    }
            }
//            if day != nil {
//                Circle()
//                    .fill(availabi .orange)
//                    .frame(width: 6, height: 6)
//            }
        }
    }
}

#Preview {
    AvailabilityScreen()
}
