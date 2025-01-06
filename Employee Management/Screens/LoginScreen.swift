//
//  LoginView.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 14/11/2024.
//

import Foundation
import SwiftUI

struct LoginScreen: View {
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        NavigationStack{
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
                            .font(AppFonts.primary(size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        // Email and Password fields
                        Group {
                            TextField("Email Address", 
                                      text: $viewModel.email,
                                      prompt: Text("Email Address")
                                .foregroundColor(.white)
                                .font(AppFonts.primary(size: 13))
                            )
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                            .keyboardType(.emailAddress)
                            TextField("Password",
                                        text: $viewModel.password,
                                        prompt: Text("Password")
                                .foregroundColor(.white)
                                .font(AppFonts.primary(size: 13))
                            )
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        }
                        .padding()
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(AppColors.secondary, lineWidth: 2)
                        )
                        .foregroundColor(.white)
                        
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        // Login Button
                        Button(action: {
                            viewModel.signIn()
                        }) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Login")
                                    .font(AppFonts.primary(size: 18))
                            }
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppColors.secondary)
                        .cornerRadius(10)
                        .disabled(viewModel.isLoading)
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                    Spacer()
                }
                .navigationDestination(isPresented: $viewModel.isAuthenticated) {
                    TabBar()
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

#Preview {
    LoginScreen()
}
