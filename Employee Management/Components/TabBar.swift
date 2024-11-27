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
            NavigationView { // Is it correct?
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

            MyHoursScreen()
                .tabItem {
                    Image(systemName: "clock")
                    Text("My Hours")
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
