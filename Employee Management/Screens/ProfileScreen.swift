//
//  ProfileScreen.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 25/11/2024.
//

import Foundation
import SwiftUI

struct ProfileScreen: View {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 20)

            if let user = viewModel.user {
                VStack{
                    // profile pic
                    Circle()
                        .fill(AppColors.tertiary)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Text(user.initials)
                                .font(.primary(size: 50))
                                .fontWeight(.bold)
                                .foregroundColor(.brandPrimary)
                        )
                    
                    // name
                    VStack(spacing: 5) {
                        Text(user.fullName)
                            .font(.primary(size: 25))
                            .fontWeight(.bold)
                            .foregroundColor(.primaryText)
                        
                        Text("\(viewModel.totalHoursWorked, specifier: "%.1f")h worked this month")
                            .font(.secondary(size: 13))
                            .foregroundColor(.secondaryText)
                    }
                    
                    Spacer().frame(height: 30)
                    
                    // contact info cards
                    VStack(spacing: 15) {
                        ContactCard(
                            icon: "envelope.fill",
                            text: user.email
                        )
                        ContactCard(
                            icon: "phone.fill",
                            text: user.phone
                        )
                    }
                }
            } else if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            Spacer()

            // logout button
            Button(action: {
                authViewModel.logOut()
            }) {
                Text("LOGOUT")
                    .font(.primary(size: 20))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(AppColors.secondary)
                    .cornerRadius(15)
                    .padding(.horizontal, 80)
            }

            Spacer().frame(height: 20)
        }
        .padding()
        .background(Color(UIColor.systemGray6).ignoresSafeArea())
    }
}

struct ContactCard: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 15) {
            Circle()
                .fill(AppColors.tertiary)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(AppColors.primary)
                        .font(.system(size: 20, weight: .bold))
                )

            Text(text)
                .font(.secondary(size: 16))
                .foregroundColor(.primaryText)

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    ProfileScreen()
}
