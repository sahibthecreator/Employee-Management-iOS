//
//  HeaderView.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 18/11/2024.
//

import Foundation
import SwiftUI

struct HeaderView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            AppColors.primary
                .clipShape(
                    RoundedCornerShape(corners: [.bottomLeft, .bottomRight], radius: 20)
                )
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("Good Morning")
                    .foregroundColor(.white)
                    .font(AppFonts.primary(size: 16))
                    .fontWeight(.bold)
                    
                Text("Bird Van Burger")
                    .foregroundColor(.white)
                    .font(AppFonts.primary(size: 24))
                    .fontWeight(.bold)

                Text("23 Sep, Monday")
                    .foregroundColor(.white)
                    .font(.caption2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()

            // Profile Image
            HStack {
                Spacer()
                Circle()
                    .fill(Color.pink)
                    .frame(width: 50, height: 50)
                    .overlay(Text("BB").foregroundColor(.white).fontWeight(.bold))
                    .padding()
            }
        }
        .frame(height: 35) 
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