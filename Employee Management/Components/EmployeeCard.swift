//
//  EmployeeCard.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 08/01/2025.
//

import Foundation
import SwiftUI

struct EmployeeCard: View {
    let user: AssignedUser
    let displayClockInTime: Bool
    
    init(user: AssignedUser, displayClockInTime: Bool = false) {
        self.user = user
        self.displayClockInTime = displayClockInTime
    }
    var body: some View {
        HStack {
            Circle()
                .fill(Color.randomAppColor())
                .frame(width: 45, height: 45)
                .overlay(
                    Text(user.initials)
                        .font(.primary(size: 20))
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading) {
                Text(user.fullName ?? "Unknown")
                    .font(.secondary(size: 17))
                
                Text(user.role)
                    .font(.secondary(size: 13))
                    .foregroundColor(.gray)
            }
            Spacer()
            if(displayClockInTime) {
                if let clockInTime = user.clockInTime {
                    Text("Clocker In At: \(clockInTime.formatted(date: .omitted, time: .shortened))")
                        .font(.secondary(size: 13))
                        .foregroundColor(.green)
                } else {
                    Text("Not Clocked In")
                        .font(.secondary(size: 13))
                        .foregroundColor(.red)
                }
            }
            
        }
        .padding()
        .background(Color.white)
    }
}
