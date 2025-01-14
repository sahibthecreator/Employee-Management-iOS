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
    @State private var navigateToAvailability = false
    @Binding var tabSelection: Int
    
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
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding()
                        } else if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .padding()
                        } else if viewModel.shifts.isEmpty {
                            Text("No upcoming shifts.")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding()
                        } else {
                            VStack(spacing: 10) {
                                ForEach(viewModel.shifts) { shift in
                                    ShiftCard(shift: shift)
                                }
                            }
                        }
                    }
                    Button(action: {
                        tabSelection = 3
                    }) {
                        HStack(spacing: 5) {
                            Image("unavailable-icon")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("Unavailable?")
                                .fontWeight(.bold)
                        }
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
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                               .padding()
                       } else if let error = viewModel.eventsErrorMessage {
                           Text(error)
                               .foregroundColor(.red)
                               .padding()
                       } else if viewModel.unassignedEvents.isEmpty {
                           Text("No upcoming events.")
                               .foregroundColor(.gray)
                               .frame(maxWidth: .infinity, maxHeight: .infinity)
                               .padding()
                       } else {
                           ForEach(viewModel.unassignedEvents) { event in
                               EventCard(event: event)
                           }
                       }
                    }
                    Button(action: {
                        tabSelection = 2
                    }) {
                        HStack(spacing: 5) {
                            Image("shift-icon")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("See more")
                                .fontWeight(.bold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppColors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
            .padding(.vertical, 10) // Hardcoded solution
        }
        .background(Color(UIColor.systemGray6))
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


