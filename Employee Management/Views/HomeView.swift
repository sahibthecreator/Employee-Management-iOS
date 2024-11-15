//
//  HomeView.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 15/11/2024.
//

import Foundation
import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            AppColors.primary
                .ignoresSafeArea()

            Text("Welcome to Home Screen!")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
}
