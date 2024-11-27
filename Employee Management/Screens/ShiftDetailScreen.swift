//
//  ShiftDetailScreen.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 27/11/2024.
//

import Foundation
import SwiftUI

struct ShiftDetailScreen: View {
    var shift: Shift
    @Environment(\.presentationMode) var presentationMode // Access presentation mode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Navigation Bar
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(AppColors.secondary)
                            Text("Home")
                                .foregroundColor(AppColors.secondary)
                        }
                    }
                    Spacer()
                }
                .padding(.bottom, 10)

                // Title
                Text(shift.title)
                    .font(.title)
                    .fontWeight(.bold)

                // Date
                Text(formattedDate(shift.date))
                    .font(.subheadline)
                    .foregroundColor(.gray)

                // Details Section
                VStack(alignment: .leading, spacing: 15) {
                    DetailRow(title: "Location:", content: shift.location)
                    DetailRow(title: "Scheduled For:", content: shift.time)
                    DetailRow(title: "Role:", content: shift.role)
                    DetailRow(title: "Break:", content: "30min")
                    DetailRow(title: "Number of Employees:", content: "15")
                    DetailRow(title: "Additional Information:", content: "Attention, bring extra something because someone, will need something somewhere", isBoxed: true)
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding()
        }
        .background(Color(UIColor.systemGray6).ignoresSafeArea())
        .navigationBarHidden(true)
    }

    // Helper to format the date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

struct DetailRow: View {
    var title: String
    var content: String
    var isBoxed: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.gray)

            if isBoxed {
                Text(content)
                    .font(.body)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            } else {
                Text(content)
                    .font(.body)
            }
        }
    }
}
