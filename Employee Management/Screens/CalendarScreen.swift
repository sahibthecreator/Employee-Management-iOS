//
//  CalendarScreen.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 25/11/2024.
//

import Foundation
import SwiftUI

struct CalendarScreen: View {
    @StateObject private var viewModel = CalendarViewModel()
    
    var body: some View {
        Header()
        VStack(spacing: 0) {
            // Tab Navigation
            CalendarTabSelector(selectedTab: $viewModel.selectedTab)

            // Week Selector
            HStack {
                Button(action: {
                    // Navigate to previous week
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(AppColors.secondary)
                        .padding()
                        .background(Circle().stroke(AppColors.secondary, lineWidth: 2))
                }

                Spacer()

                VStack {
                    Text("Week 39")
                        .fontWeight(.bold)
                    Text("23 sep. - 30 sep.")
                        .foregroundColor(.gray)
                        .font(.caption)
                }

                Spacer()

                Button(action: {
                    // Navigate to next week
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(AppColors.secondary)
                        .padding()
                        .background(Circle().stroke(AppColors.secondary, lineWidth: 2))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            // Shifts List
            ScrollView {
                VStack(spacing: 10) {
                    if viewModel.selectedTab == 0 {
                        // Display Shifts
                        ForEach(viewModel.shifts, id: \.title) { shift in
                            ShiftCardView(
                                title: shift.title,
                                location: shift.location,
                                date: shift.date,
                                time: shift.time,
                                role: shift.role,
                                teammates: shift.teammates,
                                isUnavailable: shift.isDraft
                            )
                        }
                    } else {
                        // Display Events
                        ForEach(viewModel.events, id: \.title) { event in
                            EventCardView(
                                title: event.title,
                                location: event.location,
                                date: event.date,
                                time: event.time,
                                isDraft: event.isDraft
                            )
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color(UIColor.systemGray6))
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    CalendarScreen()
}
