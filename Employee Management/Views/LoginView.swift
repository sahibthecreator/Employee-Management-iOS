//
//  LoginView.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 14/11/2024.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            AppColors.primary
                .ignoresSafeArea()
            
            VStack {
                Image("karma_kebab_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                
                Spacer()

                // Main container
                VStack(spacing: 20) {
                    Text("Hello there, login to continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    // Email and Password fields
                    Group {
                        TextField("Email Address", 
                                  text: $email,
                                  prompt: Text("Email Address")
                                            .foregroundColor(.white)
                        )
                        SecureField("Password", 
                                    text: $password,
                                    prompt: Text("Password")
                                             .foregroundColor(.white)
                        )
                    }
                    .padding()
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppColors.secondary, lineWidth: 2)
                    )
                    .foregroundColor(.white)
                    
                    // Login Button
                    Button(action: {
                        // Login action
                    }) {
                        Text("Login")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(AppColors.secondary)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
        }
    }
}
