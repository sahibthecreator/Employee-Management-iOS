//
//  ShiftDetailScreen.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 27/11/2024.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct ShiftDetailScreen: View {
    let shift: ShiftDTO
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading){
                    Text(shift.event?.venue ?? "Unknown Venue")
                        .font(.primary(size: 30))
                        .fontWeight(.bold)
                    
                    Text(shift.startTime.formatted(date: .complete, time: .omitted))
                        .font(.secondary(size:17))
                        .foregroundColor(.gray)
                }
                
                DetailRow(title: "Location", content: shift.event?.address ?? "Unknown Address")
                
                DetailRow(title: "Description", content: shift.event?.description ?? "No Description")
                
                DetailRow(title: "Scheduled For", content: "\(shift.startTime.formatted(date: .omitted, time: .shortened)) - \(shift.endTime.formatted(date: .omitted, time: .shortened))")
                
                DetailRow(title: "Role", content: shift.assignedUsers.first(where: { $0.userId == Auth.auth().currentUser?.uid })?.role ?? "Unknown Role")
                
                DetailRow(title: "Additional Information", content: shift.event?.note ?? "")
                
                DetailRow(title: "Number of Employees", content: "\(shift.assignedUsers.count)")
                
                // Employees List
                VStack(alignment: .leading, spacing: 5) {
                    Text("Employees")
                        .font(.secondary(size: 17))
                        .foregroundColor(.gray)
                    ScrollView {
                        VStack(spacing: 5) {
                            ForEach(shift.assignedUsers, id: \.userId) { user in
                                EmployeeCard(user: user)
                            }
                        }
                    }
                    .frame(height: 250)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
            }
            .padding()
        }
        .background(AppColors.bg)
    }
}
