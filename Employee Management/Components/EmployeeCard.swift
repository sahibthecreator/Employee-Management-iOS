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
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.randomAppColor())
                .frame(width: 45, height: 45)
                .overlay(
                    Text(user.initials)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                )
            
            VStack(alignment: .leading) {
                Text(user.fullName ?? "Unknown")
                    .font(.secondary(size: 17))
                
                Text(user.role)
                    .font(.secondary(size: 13))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
    }
}
