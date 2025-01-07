//
//  ToastNotification.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 07/01/2025.
//

import Foundation
import SwiftUI

struct ToastNotification: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.subheadline)
            .padding()
            .background(AppColors.primary.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(8)
            .shadow(radius: 10)
            .transition(.opacity)
            .animation(.easeInOut, value: message)
    }
}
