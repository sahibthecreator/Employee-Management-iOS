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
    @Binding var shift: ShiftDTO
    @State private var navigateToTaskScreen: Bool = false
    @State var showConfirmationAlert: Bool = false
    @State private var isLoading = false
    @State private var totalTasksForRole: Int? = nil

    private let shiftService = ShiftService()
    
    var body: some View {
        NavigationLink(destination: ShiftDetailScreen(shift: shift)) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(shift.event?.venue ?? "Unknown Venue")
                            .font(.primary(size: 17))
                            .foregroundColor(.primaryText)
                        Text(shift.event?.address ?? "No Address")
                            .font(.secondary(size: 15))
                            .foregroundColor(.secondaryText)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        HStack(spacing: 10) {
                            Image("calendar-icon")
                                .resizable()
                                .frame(width: 19, height: 19)
                            Text(shift.startTime.formatted(date: .abbreviated, time: .omitted))
                                .font(.primary(size: 17))
                                .foregroundColor(.secondaryText)
                        }
                        Text("\(shift.startTime.formatted(date: .omitted, time: .shortened)) - \(shift.endTime.formatted(date: .omitted, time: .shortened))")
                            .font(.secondary(size: 15))
                            .foregroundColor(.secondaryText)
                    }
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Teammates")
                            .font(.secondary(size: 15))
                            .foregroundColor(.secondaryText)
                            HStack(spacing: -10) {
                                let maxDisplay = 3
                                let remaining = shift.assignedUsers.count - maxDisplay
                                
                                ForEach(Array(shift.assignedUsers.prefix(maxDisplay).enumerated()), id: \.element.userId) { index, teammate in
                                    Circle()
                                        .fill(teammateBadgeColors[index])
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Text(teammate.initials)
                                                .font(.primary(size: 15))
                                                .foregroundColor(.white)
                                        )
                                }
                                
                                if remaining > 0 {
                                    Circle()
                                        .fill(Color(hex: "662C83"))
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Text("+\(remaining)")
                                                .font(.primary(size: 14))
                                                .foregroundColor(.white)
                                        )
                                }
                            }
                    }
                    
                    Spacer()
                    HStack(spacing: 10) {
                        Image("role-icon")
                            .resizable()
                            .frame(width: 18, height: 18)
                        Text(shift.assignedUsers.first(where: { $0.userId == Auth.auth().currentUser?.uid })?.role ?? "Role N/A")
                            .font(.secondary(size: 15))
                            .foregroundColor(.secondaryText)
                    }
                }
                // Clock in/out / go to tasks buttons
                if Calendar.current.isDateInToday(shift.startTime) {
                    if let currentUser = shift.assignedUsers.first(where: { $0.userId == Auth.auth().currentUser?.uid }) {
                        if let totalTasks = totalTasksForRole {
                            if currentUser.clockInTime == nil {
                                Button(action: {
                                    showConfirmationAlert = true
                                }) {
                                    if isLoading {
                                        ProgressView()
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                    } else {
                                        Text("Clock In")
                                            .font(.primary(size: 17))
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(AppColors.secondary)
                                            .cornerRadius(10)
                                    }
                                }
                            } else if currentUser.completedTasks?.count != totalTasks  {
                                Button(action: {
                                    navigateToTaskScreen = true
                                }) {
                                    Text("Open Tasks")
                                        .font(.primary(size: 17))
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.secondary)
                                        .cornerRadius(10)
                                }
                            } else if currentUser.clockOutTime == nil {
                                Button(action: {
                                    showConfirmationAlert = true
                                }) {
                                    if isLoading {
                                        ProgressView()
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                    } else {
                                        Text("Clock Out")
                                            .font(.primary(size: 17))
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(AppColors.secondary)
                                            .cornerRadius(10)
                                    }
                                }
                            } else {
                                Text("Completed")
                                    .font(.primary(size: 17))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(AppColors.secondary)
                                    .cornerRadius(10)
                                    .opacity(0.5)
                            }
                        } else {
                            ProgressView("Loading...")
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            .navigationDestination(isPresented: $navigateToTaskScreen) {
                TaskScreen(shift: shift)
            }
            .alert(isPresented: $showConfirmationAlert) {
                let currentUser = shift.assignedUsers.first(where: { $0.userId == Auth.auth().currentUser?.uid })
                return Alert(
                    title: Text(currentUser?.clockInTime == nil ? "Clock In" : "Clock Out"),
                    message: Text("Are you sure you want to clock in?"),
                    primaryButton: .default(Text("Yes"), action: {
                        currentUser?.clockInTime == nil ? performClockIn() : performClockOut()
                    }),
                    secondaryButton: .cancel()
                )
            }
            .onAppear {
                fetchTasksForRole()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func performClockIn() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        shiftService.clockIn(for: shift, userId: userId) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let updatedShift):
                    shift.assignedUsers = updatedShift.assignedUsers
                case .failure(let error):
                    print("Error during clock in: \(error)")
                }
            }
        }
    }

    private func performClockOut() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        shiftService.clockOut(for: shift, userId: userId) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let updatedShift):
                    shift.assignedUsers = updatedShift.assignedUsers
                case .failure(let error):
                    print("Error during clock out: \(error)")
                }
            }
        }
    }

    private func fetchTasksForRole() {
        guard let currentUser = shift.assignedUsers.first(where: { $0.userId == Auth.auth().currentUser?.uid }) else { return }
        shiftService.fetchRoleTasks(role: currentUser.role) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tasks):
                    totalTasksForRole = tasks.count
                case .failure(let error):
                    print("Error fetching tasks for role: \(error)")
                }
            }
        }
    }
}
