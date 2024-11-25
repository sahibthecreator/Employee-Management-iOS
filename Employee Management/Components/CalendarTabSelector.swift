//
//  CalendarTabSelector.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 25/11/2024.
//

import Foundation
import SwiftUI

struct CalendarTabSelector: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack {
            Button(action: {
                selectedTab = 0
            }) {
                Text("MY SCHEDULE")
                    .fontWeight(.bold)
                    .font(.system(size: 10))
                    .foregroundColor(selectedTab == 0 ? .white : AppColors.primary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedTab == 0 ? AppColors.secondary : Color.clear)
                    .cornerRadius(20)
            }

            Button(action: {
                selectedTab = 1
            }) {
                Text("UPCOMING EVENTS")
                    .fontWeight(.bold)
                    .font(.system(size: 10))
                    .foregroundColor(selectedTab == 1 ? .white : AppColors.primary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedTab == 1 ? AppColors.secondary : Color.clear)
                    .cornerRadius(20)
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}
