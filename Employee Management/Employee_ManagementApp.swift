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
    @StateObject private var authViewModel = AuthViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State private var showTransition = false
        
    var body: some Scene {
        WindowGroup {
            ZStack {
                if authViewModel.authStateIsLoading {
                    LaunchScreen()
                } else if authViewModel.isAuthenticated {
                    TabBar()
                        .environmentObject(authViewModel)
                        .transition(.opacity)
                } else {
                    LoginScreen()
                        .environmentObject(authViewModel)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: authViewModel.isAuthenticated)
        }
    }
}


