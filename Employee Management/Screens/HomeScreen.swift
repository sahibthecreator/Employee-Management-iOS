//
//  HomeView.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 15/11/2024.
//

import Foundation
import SwiftUI

struct HomeScreen: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            Header()

            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Upcoming Shifts
                    SectionHeaderView(title: "Upcoming Shifts")
                    VStack(spacing: 10) {
                        if viewModel.isLoading {
                            ProgressView("Loading Shifts...")
                                .padding()
                        } else if viewModel.shifts.isEmpty {
                            Text("No upcoming shifts.")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            VStack(spacing: 10) {
                                ForEach(viewModel.shifts) { shift in
                                    ShiftCard(shift: shift)
                                }
                            }
                        }
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
                        if viewModel.eventsIsLoading {
                           ProgressView("Loading Events...")
                               .padding()
                       } else if let error = viewModel.eventsErrorMessage {
                           Text(error)
                               .foregroundColor(.red)
                               .padding()
                       } else if viewModel.unassignedEvents.isEmpty {
                           Text("No upcoming events.")
                               .foregroundColor(.gray)
                               .padding()
                       } else {
                           ForEach(viewModel.unassignedEvents) { event in
                               EventCard(event: event)
                           }
                       }
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
            .padding(.top, 10) // Hardcoded solution
        }
        .background(Color(UIColor.systemGray6))
        .ignoresSafeArea(edges: .bottom)
    }
}

struct SectionHeaderView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.primary(size: 18))
            .fontWeight(.bold)
            .foregroundColor(.black)
    }
}

//struct ShiftCardView: View {
//    let shift: Shift
//    @State private var navigateToTaskScreen: Bool = false // State to control navigation
//    
//    var body: some View {
//        NavigationLink(destination: ShiftDetailScreen(shift: shift)) {
//            VStack(alignment: .leading, spacing: 10) {
//                HStack {
//                    VStack(alignment: .leading) {
//                        Text(shift.title)
//                            .font(.headline)
//                            .fontWeight(.bold)
//                        Text(shift.location)
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                    }
//                    Spacer()
//                    VStack(alignment: .trailing) {
//                        Text(shift.date.formatted) // Use formatted date
//                            .font(.subheadline)
//                            .fontWeight(.bold)
//                        Text(shift.time)
//                            .font(.subheadline)
//                            .foregroundColor(shift.isDraft ?? false ? .red : .gray)
//                    }
//                }
//                
//                HStack {
//                    VStack(alignment: .leading) {
//                        Text("Teammates")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                        HStack(spacing: -10) {
//                            ForEach(shift.teammates, id: \.self) { teammate in
//                                Circle()
//                                    .fill(Color.randomAppColor())
//                                    .frame(width: 30, height: 30)
//                                    .overlay(
//                                        Text(teammate)
//                                            .font(.caption)
//                                            .foregroundColor(.white)
//                                    )
//                            }
//                        }
//                    }
//                    
//                    HStack {
//                        Spacer()
//                        Text(shift.role)
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                    }
//                    
//                }
//                if shift.date.isToday {
//                   Button(action: {
//                       navigateToTaskScreen = true // Trigger navigation
//                   }) {
//                       Text("Clock In")
//                           .foregroundColor(.white)
//                           .padding()
//                           .frame(maxWidth: .infinity)
//                           .background(AppColors.secondary)
//                           .cornerRadius(10)
//                   }
//               }
//            }
//            .padding()
//            .background(Color.white)
//            .cornerRadius(10)
//            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
//        }
//        .buttonStyle(PlainButtonStyle())
//        .navigationDestination(isPresented: $navigateToTaskScreen) {
//            TaskScreen(shift: shift)
//                .navigationTitle(shift.title)
//        }
//    }
//}


#Preview {
    HomeScreen()
}


