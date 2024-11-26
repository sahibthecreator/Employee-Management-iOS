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
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(AppColors.secondary)
                .frame(height: 40)

            // Animated Highlight
            GeometryReader { geometry in
                let buttonWidth = geometry.size.width / 2
                let buttonHeight = geometry.size.height

                RoundedRectangle(cornerRadius: 5)
                    .fill(AppColors.primary)
                    .frame(width: buttonWidth - 10, height: buttonHeight - 16) // Highlight size
                    .offset(x: CGFloat(selectedTab) * buttonWidth + 5, y: 8.5) // Move based on tab
                    .animation(.easeInOut(duration: 0.3), value: selectedTab)
            }

            // Tabs
            HStack(spacing: 0) {
                Button(action: {
                    withAnimation {
                        selectedTab = 0
                    }
                }) {
                    Text("MY SCHEDULE")
                        .fontWeight(.bold)
                        .font(AppFonts.primary(size: 13))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                Button(action: {
                    withAnimation {
                        selectedTab = 1
                    }
                }) {
                    Text("OPEN SHIFTS")
                        .fontWeight(.bold)
                        .font(AppFonts.primary(size: 13))
                        .foregroundColor(.white )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .frame(height: 45)
        .padding(.horizontal, 60)
    }
}

#Preview {
    CalendarScreen()
}
