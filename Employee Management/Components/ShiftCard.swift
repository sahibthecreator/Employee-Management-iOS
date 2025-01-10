//
//  ShiftCard.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 06/01/2025.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct ShiftCard: View {
    let shift: ShiftDTO
    @State private var navigateToTaskScreen: Bool = false
    @State private var showConfirmationAlert: Bool = false
    
    var body: some View {
        NavigationLink(destination: ShiftDetailScreen(shift: shift)) {
            VStack(alignment: .leading, spacing: 10) {
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(shift.event?.venue ?? "Unknown Venue")
                            .font(.headline)
                            .fontWeight(.bold)
                        Text(shift.event?.address ?? "No Address")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(shift.startTime.formatted(date: .abbreviated, time: .omitted))
                           .font(.headline)
                           .fontWeight(.bold)
                        Text("\(shift.startTime.formatted(date: .omitted, time: .shortened)) - \(shift.endTime.formatted(date: .omitted, time: .shortened))")
                           .font(.subheadline)
                           .foregroundColor(.gray)
                    }
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Teammates")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            HStack(spacing: -10) {
                                let maxDisplay = 3
                                let remaining = shift.assignedUsers.count - maxDisplay
                                
                                ForEach(Array(shift.assignedUsers.prefix(maxDisplay).enumerated()), id: \.element.userId) { index, teammate in
                                    Circle()
                                        .fill(teammateBadgeColors[index])
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Text(teammate.initials)
                                                .font(.caption)
                                                .foregroundColor(.white)
                                        )
                                }
                                
                                if remaining > 0 {
                                    Circle()
                                        .fill(Color(hex: "662C83"))
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Text("+\(remaining)")
                                                .font(.caption)
                                                .foregroundColor(.white)
                                        )
                                }
                            }
                    }
                    
                    Spacer()
                    Text(shift.assignedUsers.first(where: { $0.userId == Auth.auth().currentUser?.uid })?.role ?? "Role N/A")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                if Calendar.current.isDateInToday(shift.startTime) {
                    Button(action: {
                        navigateToTaskScreen = true
                    }) {
                        Text("Open Tasks")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(AppColors.secondary)
                            .cornerRadius(10)
                    }
//                    .alert(isPresented: $showClockInConfirmation) {
//                        Alert(
//                            title: Text("Clock In"),
//                            message: Text("Are you sure you want to clock in?"),
//                            primaryButton: .default(Text("Yes"), action: {
//                                navigateToTaskScreen = true
//                            }),
//                            secondaryButton: .cancel()
//                        )
//                    }
//                    switch state {
//                    case .needToClockIn:
//                        Button(action: {
//                            showConfirmationAlert = true
//                        }) {
//                            Text("Clock In")
//                                .foregroundColor(.white)
//                                .padding()
//                                .frame(maxWidth: .infinity)
//                                .background(AppColors.secondary)
//                                .cornerRadius(10)
//                        }
//                        .alert(isPresented: $showConfirmationAlert) {
//                            Alert(
//                                title: Text("Clock In"),
//                                message: Text("Are you sure you want to clock in?"),
//                                primaryButton: .default(Text("Yes"), action: {
//                                    navigateToTaskScreen = true
//                                }),
//                                secondaryButton: .cancel()
//                            )
//                        }
//                    case .clockedIn:
//                        Button(action: {
//                            navigateToTaskScreen = true
//                        }) {
//                            Text("Go to Tasks")
//                                .foregroundColor(.white)
//                                .padding()
//                                .frame(maxWidth: .infinity)
//                                .background(AppColors.secondary)
//                                .cornerRadius(10)
//                        }
//                    case .needToClockOut:
//                        Button(action: {
//                            navigateToTaskScreen = true
//                        }) {
//                            Text("Go to Tasks")
//                                .foregroundColor(.white)
//                                .padding()
//                                .frame(maxWidth: .infinity)
//                                .background(AppColors.secondary)
//                                .cornerRadius(10)
//                        }
//                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            .navigationDestination(isPresented: $navigateToTaskScreen) {
                TaskScreen(shift: shift)
            }
        }
        .buttonStyle(PlainButtonStyle())
//        .navigationTitle(shift.event?.venue ?? "Unknown venue")
    }
}
