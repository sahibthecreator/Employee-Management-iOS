//
//  Employee_ManagementApp.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 14/11/2024.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct Employee_ManagementApp: App {
    @StateObject private var authViewModel = AuthViewModel() // old approach
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
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


