//
//  WeekSelector.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 26/11/2024.
//

import Foundation
import SwiftUI

struct WeekSelector: View {
    let currentWeek: Date
    let onPreviousWeek: () -> Void
    let onNextWeek: () -> Void
    let onToggleFullMonthView: () -> Void

    var body: some View {
        HStack {
            Button(action: onPreviousWeek) {
                Image(systemName: "chevron.left")
                    .foregroundColor(AppColors.secondary)
                    .padding()
                    .background(Circle().stroke(AppColors.secondary, lineWidth: 2))
            }

            Spacer()
            Spacer()
            VStack {
                Text("Week \(Calendar.current.component(.weekOfYear, from: currentWeek))")
                    .fontWeight(.bold)
                Text("\(formattedDateRange(for: currentWeek))")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            Button(action: onToggleFullMonthView) {
                Image(systemName: "calendar")
                    .foregroundColor(AppColors.secondary)
                    .padding()
            }

            Spacer()

            Button(action: onNextWeek) {
                Image(systemName: "chevron.right")
                    .foregroundColor(AppColors.secondary)
                    .padding()
                    .background(Circle().stroke(AppColors.secondary, lineWidth: 2))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }

    private func formattedDateRange(for date: Date) -> String {
        let startOfWeek = Calendar.current.startOfWeek(for: date)
        let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return "\(formatter.string(from: startOfWeek)) - \(formatter.string(from: endOfWeek))"
    }
}
