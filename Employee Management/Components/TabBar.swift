//
//  TabBar.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 25/11/2024.
//

import Foundation
import SwiftUI

struct TabBar: View {
    @State private var tabSelection = 1
    
    var body: some View {
        TabView(selection: $tabSelection) {
            NavigationStack {
                HomeScreen(tabSelection: $tabSelection)
            }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(1)
            NavigationStack {
                CalendarScreen()
            }
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(2)

            AvailabilityScreen()
                .tabItem {
                    Image(systemName: "clock")
                    Text("My Availability")
                }
                .tag(3)

            ProfileScreen()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
                .tag(4)
        }
        .background(Color.white)
    }
}

#Preview {
    TabBar()
}
