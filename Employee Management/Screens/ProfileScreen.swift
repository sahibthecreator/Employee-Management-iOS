//
//  ProfileScreen.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 25/11/2024.
//

import Foundation
import SwiftUI

struct ProfileScreen: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 20)

            // Profile Picture
            Circle()
                .fill(AppColors.tertiary)
                .frame(width: 100, height: 100)
                .overlay(
                    Text("BB")
                        .font(AppFonts.primary(size: 50))
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.primary)
                )

            // Name and Work Hours
            VStack(spacing: 5) {
                Text("BIRD VAN BURGER")
                    .font(AppFonts.primary(size: 25))
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.dark)

                Text("24.5h worked this month")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }

            Spacer().frame(height: 10)

            // Contact Info Cards
            VStack(spacing: 15) {
                ContactCard(
                    icon: "envelope.fill",
                    text: "Birdvanburger@gmail.com"
                )
                ContactCard(
                    icon: "phone.fill",
                    text: "+3168605234"
                )
            }

            Spacer()

            // Logout Button
            Button(action: {
                viewModel.logOut()
            }) {
                Text("LOGOUT")
                    .font(AppFonts.primary(size: 20))
                    .fontWeight(.bold)
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
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.dark)

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
