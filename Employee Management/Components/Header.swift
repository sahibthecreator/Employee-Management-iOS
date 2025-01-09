//
//  HeaderView.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 18/11/2024.
//

import Foundation
import SwiftUI

struct Header: View {
    @StateObject private var viewModel = HeaderViewModel()
    
    var body: some View {
        ZStack(alignment: .center) {
            AppColors.primary
                .clipShape(
                    RoundedCornerShape(corners: [.bottomLeft, .bottomRight], radius: 20)
                )
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text(viewModel.greeting)
                    .foregroundColor(.white)
                    .font(.primary(size: 16))
                    .fontWeight(.bold)
                    
                Text(viewModel.fullName)
                    .foregroundColor(.white)
                    .font(.primary(size: 24))
                    .fontWeight(.bold)

                Text(viewModel.currentDate)
                    .foregroundColor(.white)
                    .font(.secondary(size: 12))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()

            // Profile Image
            HStack {
                Spacer()
                Circle()
                    .fill(AppColors.tertiary)
                    .frame(width: 50, height: 50)
                    .overlay(Text(viewModel.initials).foregroundColor(AppColors.primary).font(AppFonts.primary()))
                    .padding()
            }
        }
        .frame(height: 75)
    }
}

struct RoundedCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
