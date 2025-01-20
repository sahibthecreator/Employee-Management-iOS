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
                        .foregroundColor(.primaryText)
                    
                    Text(shift.startTime.formatted(date: .complete, time: .omitted))
                        .font(.secondary(size:17))
                        .foregroundColor(.secondaryText)
                }
                
                DetailRow(title: "Address", content: shift.event?.address ?? "Unknown Address")
                
                DetailRow(title: "Description", content: shift.event?.description ?? "No Description")
                
                DetailRow(title: "Scheduled For", content: "\(shift.startTime.formatted(date: .omitted, time: .shortened)) - \(shift.endTime.formatted(date: .omitted, time: .shortened))")
                
                DetailRow(title: "Role", content: shift.assignedUsers.first(where: { $0.userId == Auth.auth().currentUser?.uid })?.role ?? "Unknown Role")
                
                DetailRow(title: "Additional Information", content: shift.event?.note ?? "No additional information")
                
                DetailRow(title: "Number of Employees", content: "\(shift.assignedUsers.count)")
        
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(AppColors.bg)
    }
}
