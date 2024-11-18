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
        VStack(spacing: 0) {
            HeaderView()

            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Upcoming Shifts
                    SectionHeaderView(title: "Upcoming Shifts")
                    VStack(spacing: 10) {
                        ShiftCardView(
                            title: "Vegan Summer Festival",
                            location: "Prinses 202, Utrecht",
                            date: "SEP 24, 2024",
                            time: "07:00 – 15:00",
                            role: "Trucker",
                            teammates: ["AZ", "BR", "SZ", "+3"], 
                            isUnavailable: true
                        )
                        ShiftCardView(
                            title: "Kebab Festival",
                            location: "Haarlemplein, Amsterdam",
                            date: "SEP 26, 2024",
                            time: "07:00 – 15:00",
                            role: "Building crew",
                            teammates: ["AZ", "BR", "SZ", "+3"],
                            isUnavailable: true
                        )
                    }
                    Button(action: {}) {
                        Text("🚫 Unavailable?")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(AppColors.primary)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    // Upcoming Events
                    SectionHeaderView(title: "Upcoming Events")
                    VStack(spacing: 10) {
                        ShiftCardView(
                            title: "Oz Festival",
                            location: "Prinses 91, Utrecht",
                            date: "SEP 25, 2024",
                            time: "07:00 – 15:00",
                            role: "Trucker",
                            teammates: ["AZ", "BR", "SZ", "+3"], 
                            isUnavailable: true
                        )
                    }
                    Button(action: {}) {
                        Text("💼 See more")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(AppColors.primary)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .padding(.top, 25) // Hardcoded solution

            // Bottom Tab Bar
            TabBarView()
        }
        .background(Color(UIColor.systemGray6))
        .ignoresSafeArea(edges: .bottom)
    }
}

struct SectionHeaderView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.black)
    }
}

struct ShiftCardView: View {
    let title: String
    let location: String
    let date: String
    let time: String
    let role: String?
    let teammates: [String]?
    let isUnavailable: Bool?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                    Text(location)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(date)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text(time)
                        .font(.subheadline)
                        .foregroundColor(isUnavailable ?? false ? .red : .gray)
                }
            }

            if let teammates = teammates {
                Text("Teammates")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                HStack {
                    ForEach(teammates, id: \.self) { teammate in
                        Circle()
                            .fill(AppColors.secondary)
                            .frame(width: 30, height: 30)
                            .overlay(Text(teammate).font(.caption).foregroundColor(.white))
                    }
                }
            }

            if let role = role {
                HStack {
                    Spacer()
                    Text(role)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }

//            if isUnavailable ?? false {
//                Button(action: {}) {
//                    Text("🚫 Unavailable?")
//                        .fontWeight(.bold)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(AppColors.primary)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

struct TabBarView: View {
    var body: some View {
        HStack {
            TabItem(icon: "house.fill", title: "Home")
            TabItem(icon: "calendar", title: "Calendar")
            TabItem(icon: "clock", title: "My Hours")
            TabItem(icon: "person.circle", title: "Profile")
        }
        .padding()
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -5)
    }
}

struct TabItem: View {
    let icon: String
    let title: String

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.gray)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomeView()
}
