//
//  ShiftCard.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 07/01/2025.
//

import Foundation
import SwiftUI

struct ShiftCard: View {
    let shift: ShiftDTO
    let event: EventDTO?
    @State private var navigateToTaskScreen: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading) {
                    Text(event?.venue ?? "Unknown Venue")
                        .font(.headline)
                        .fontWeight(.bold)
                    Text(event?.address ?? "No Address")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(shift.startTime.formatted(date: .abbreviated, time: .shortened))
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                }
            }
            
            HStack {
                Spacer()
                Text(shift.roleID == 0 ? "No Role" : "Role \(shift.roleID)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            if shift.startTime.isToday {
                Button(action: {
                    navigateToTaskScreen = true
                }) {
                    Text("Clock In")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppColors.secondary)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .navigationDestination(isPresented: $navigateToTaskScreen) {
//            TaskScreen(shift: shift)
        }
    }
}
