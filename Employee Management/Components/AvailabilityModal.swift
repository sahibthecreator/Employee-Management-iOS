//
//  AvailabilityModal.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 04/12/2024.
//

import Foundation
import SwiftUI

struct AvailabilityModal: View {
    @Binding var isShowingModal: Bool
    @ObservedObject var viewModel: AvailabilityViewModel

    @State private var selectedOption: AvailabilityOption = .availableEntireDay
    @State private var startTime: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
    @State private var endTime: Date = Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date())!

    @State private var endDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    
    var onSaveSuccess: (String) -> Void
    
    private var isDateTooSoon: Bool {
        let twoWeeksFromNow = Calendar.current.date(byAdding: .day, value: 14, to: Date())!
        return viewModel.selectedDate < twoWeeksFromNow
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("CHANGE AVAILABILITY")
                .font(.primary(size: 20))
                .foregroundColor(.primaryText)
            if isDateTooSoon {
                Text("Some options are available only for dates at least 2 weeks from today.")
                    .font(.secondary(size: 14))
                    .foregroundColor(.secondaryText)
            }
            
            // Availability Options
            VStack(spacing: 15) {
                AvailabilityOptionRow(
                    title: "Available entire day",
                    option: .availableEntireDay,
                    selectedOption: $selectedOption
                )
                AvailabilityOptionRow(
                    title: "Unavailable entire day",
                    option: .unavailableEntireDay,
                    selectedOption: $selectedOption
                )
                .disabled(isDateTooSoon)
                .opacity(isDateTooSoon ? 0.5 : 1)
                
                AvailabilityOptionRow(
                    title: "Available from",
                    option: .specificTimeRange,
                    selectedOption: $selectedOption
                )
                .disabled(isDateTooSoon)
                .opacity(isDateTooSoon ? 0.5 : 1)
                
                if selectedOption == .specificTimeRange {
                    HStack {
                        DatePicker("Start", selection: $startTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .frame(width: 100)
                        Text("-")
                        DatePicker("End", selection: $endTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .frame(width: 100)
                    }
                }
                AvailabilityOptionRow(
                    title: "Unavailable until",
                    option: .unavailableUntil,
                    selectedOption: $selectedOption
                )
                .disabled(isDateTooSoon)
                .opacity(isDateTooSoon ? 0.5 : 1)
                
                if selectedOption == .unavailableUntil {
                    HStack {
                        DatePicker("Til Date", selection: $endDate, displayedComponents: .date)
                            .labelsHidden()
                    }
                }
            }
            
            // Save Button
            Button(action: {
                saveAvailability()
                isShowingModal = false
            }) {
                Text("SAVE")
                    .foregroundColor(.white)
                    .font(.primary(size: 20))
                    .frame(maxWidth: .infinity,  minHeight: 50)
                    .padding(.horizontal, 80)
                    .background(AppColors.secondary)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .onAppear {
            setupInitialDates()
        }
    }
    
    private func setupInitialDates() {
        endDate = Calendar.current.date(byAdding: .day, value: 2, to: viewModel.selectedDate) ?? viewModel.selectedDate
    }

    private func saveAvailability() {
        switch selectedOption {
        case .availableEntireDay:
            viewModel.deleteAvailability()
            onSaveSuccess("Availability Updated")
        case .unavailableEntireDay:
            viewModel.saveAvailability(to: "Unavailable Entire Day")
            onSaveSuccess("Marked Unavailable")
        case .specificTimeRange:
            let formattedRange = "\(formattedTime(startTime)) - \(formattedTime(endTime))"
            viewModel.saveAvailability(to: formattedRange, startTime: startTime.toFirestoreString(), endTime: endTime.toFirestoreString())
            onSaveSuccess("Availability Updated")
        case .unavailableUntil:
            endDate = Calendar.current.date(byAdding: .day, value: -1, to: endDate) ?? endDate // until is exclusive, so we won't update availability of last day
            viewModel.saveAvailabilityForDateRange(endDate: endDate)
            onSaveSuccess("Marked Unavailable for Multiple Days")
        }
    }

    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}


struct AvailabilityOptionRow: View {
    let title: String
    let option: AvailabilityOption
    @Binding var selectedOption: AvailabilityOption

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(selectedOption == option ? .primaryText : .secondaryText)
                .font(.secondary(size: 15))
            Spacer()
            Circle()
                .stroke(selectedOption == option ? AppColors.secondary : Color.gray, lineWidth: 2)
                .frame(width: 24, height: 24)
                .overlay(
                    Circle()
                        .fill(AppColors.secondary)
                        .frame(width: 12, height: 12)
                        .opacity(selectedOption == option ? 1 : 0)
                )
        }
        .onTapGesture {
            selectedOption = option
        }
    }
}

enum AvailabilityOption {
    case availableEntireDay
    case unavailableEntireDay
    case specificTimeRange
    case unavailableUntil
}
