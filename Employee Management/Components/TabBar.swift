//
//  TabBar.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 25/11/2024.
//

import Foundation
import SwiftUI

struct TabBar: View {
    
    var body: some View {
        TabView {
            NavigationStack {
                HomeScreen()
            }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            NavigationView {
                CalendarScreen()
            }
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }

            AvailabilityScreen()
                .tabItem {
                    Image(systemName: "clock")
                    Text("My Availability")
                }

            ProfileScreen()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
        }
        .background(Color.white)
    }
}

#Preview {
    TabBar()
}
