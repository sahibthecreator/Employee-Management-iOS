//
//  FullCalendar.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 26/11/2024.
//

import Foundation
import SwiftUI

struct FullCalendar: View {
    @ObservedObject var viewModel: FullCalendarViewModel

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    viewModel.moveMonth(by: -1)
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(AppColors.secondary)
                        .padding()
                }
                Spacer()
                Text(viewModel.monthYearString)
                    .font(.secondary(size: 17))
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    viewModel.moveMonth(by: 1)
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(AppColors.secondary)
                        .padding()
                }
            }

            // Weekdays
            HStack {
                ForEach(viewModel.weekdaySymbols(), id: \.self) { weekday in
                    Text(weekday)
                        .font(.secondary(size: 11))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()

            // dates grid
            VStack {
                ForEach(viewModel.daysInGrid.chunked(into: 7), id: \.self) { week in
                    HStack {
                        ForEach(week, id: \.self) { date in
                            Button(action: {
                                if let date = date {
                                    viewModel.selectDate(date)
                                }
                            }) {
                                if let date = date {
                                    Text(viewModel.dayString(from: date))
                                        .font(.secondary(size: 17))
                                        .foregroundColor(viewModel.isSameDate(date, viewModel.selectedDate) ? .white : .black)
                                        .frame(width: 40, height: 40)
                                        .background(
                                            viewModel.isSameDate(date, viewModel.selectedDate) ? Color.secondary : Color.clear
                                        )
                                        .clipShape(Circle())
                                } else {
                                    Text("")
                                        .frame(width: 40, height: 40)
                                }
                            }
                            .disabled(date == nil)
                        }
                    }
                }
            }
        }
        .padding()
    }
}
