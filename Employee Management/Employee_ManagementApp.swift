//
//  Employee_ManagementApp.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 14/11/2024.
//

import SwiftUI

@main
struct Employee_ManagementApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                TabBar()
                    .environmentObject(authViewModel)
            } else {
                LoginScreen()
                    .environmentObject(authViewModel)
            }
        }
    }
}


