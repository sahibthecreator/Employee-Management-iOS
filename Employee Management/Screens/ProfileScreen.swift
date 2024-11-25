//
//  ProfileScreen.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 25/11/2024.
//

import Foundation
import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            Text("Profile Screen")
                .font(.largeTitle)
                .foregroundColor(.pink)

            Button(action: {
                authViewModel.logOut()
            }) {
                Text("Log Out")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}
