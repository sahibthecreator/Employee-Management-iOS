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

            
            if viewModel.isFullMonthView {
               FullCalendar(
                   selectedDate: $viewModel.currentWeek,
                   onSelectWeek: viewModel.selectWeek
               )
           } else {
               WeekSelector(
                   currentWeek: viewModel.currentWeek,
                   onPreviousWeek: viewModel.previousWeek,
                   onNextWeek: viewModel.nextWeek,
                   onToggleFullMonthView: { viewModel.isFullMonthView.toggle() }
               )
           }
            
            // Shifts List
            ScrollView {
                VStack(spacing: 10) {
                    if viewModel.selectedTab == 0 {
                        // Display Shifts
                        ForEach(viewModel.shifts, id: \.title) { shift in
                            ShiftCardView(
                               shift: shift
                            )
                        }
                    } else {
                        // Display Events
                        ForEach(viewModel.events, id: \.title) { event in
                            EventCardView(
                                event: event
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
