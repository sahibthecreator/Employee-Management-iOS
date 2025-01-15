//
//  CalendarScreen.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 25/11/2024.
//

import Foundation
import SwiftUI

struct CalendarScreen: View {
    @StateObject var viewModel: CalendarViewModel
    
    init(viewModel: CalendarViewModel = CalendarViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Header()
            
            // Tab Navigation
            CalendarTabSelector(selectedTab: $viewModel.selectedTab)
                .padding(.top, 10)
            
            if viewModel.isFullMonthView {
                FullCalendar(viewModel: FullCalendarViewModel(
                    selectedDate: viewModel.currentWeek,
                    onSelectWeek:  viewModel.selectWeek)
                )
            } else {
                WeekSelector(
                    currentWeek: viewModel.currentWeek,
                    onPreviousWeek: viewModel.previousWeek,
                    onNextWeek: viewModel.nextWeek,
                    onToggleFullMonthView: { viewModel.isFullMonthView.toggle() }
                )
            }
            
            // Display Loading or Content
            ScrollView {
                VStack(spacing: 10) {
                    if viewModel.selectedTab == 0 {
                        if viewModel.isShiftsLoading {
                            ProgressView("Loading shifts...")
                        } else if let shiftError = viewModel.shiftErrorMessage {
                            Text(shiftError)
                                .foregroundColor(.red)
                        } else if viewModel.shifts.isEmpty {
                            Text("No shifts for this week.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach($viewModel.shifts) { $shift in
                                ShiftCard(shift: $shift)
                            }
                        }
                    }
                    else {
                        if viewModel.isEventsLoading {
                            ProgressView("Loading events...")
                        } else if let eventError = viewModel.eventErrorMessage {
                            Text(eventError)
                                .foregroundColor(.red)
                        } else if viewModel.events.isEmpty {
                            Text("No upcoming events.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(viewModel.events) { event in
                                EventCard(event: event)
                            }
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
