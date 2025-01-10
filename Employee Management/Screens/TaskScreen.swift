//
//  TaskScreen.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 09/12/2024.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct TaskScreen: View {
    @StateObject private var viewModel: TaskViewModel
    
//    init(shift: ShiftDTO) {
//        _viewModel = StateObject(wrappedValue: TaskViewModel(shift: shift))
//    }
    init(shift: ShiftDTO) {
        _viewModel = StateObject(wrappedValue: TaskViewModel(shift: shift))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 50) {
                // Shift Details
                VStack(alignment: .center, spacing: 5) {
                    Text(viewModel.shift.event?.venue ?? "Unknown Venue")
                        .font(.primary())
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    HStack(spacing: 10) {
                        Image("location-icon")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text(viewModel.shift.event?.address ?? "Unknown Address")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }

                    HStack(spacing: 10) {
                        Image("time-icon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("\(viewModel.shift.startTime.formatted(date: .omitted, time: .shortened)) - \(viewModel.shift.endTime.formatted(date: .omitted, time: .shortened))")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        Image("role-icon")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text(viewModel.shift.role(for: Auth.auth().currentUser?.uid))
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                }
                .frame(maxWidth: .infinity)

                // Task List
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("TASK LIST")
                            .font(.primary(size: 24))
                            .fontWeight(.bold)
                        Spacer()
                        HStack {
                            CircularProgressView(progress: viewModel.progress)
                                .frame(width: 20)
                            Text("\(viewModel.completedCount)/\(viewModel.tasks.count) Complete")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                        
                    }
                    TaskItem(
                        task: .constant(TaskDTO(
                            id: -1,
                            title: "Clock In",
                            requiresImage: false,
                            isDone: viewModel.shift.assignedUser(for: viewModel.currentUserId)?.clockInTime != nil,
                            time: viewModel.shift.assignedUser(for: viewModel.currentUserId)?.clockInTime?.formatted(date: .omitted, time: .shortened)
                        ))
                    ) {
                        viewModel.showClockInAlert = true
                    }
                    .alert(isPresented: $viewModel.showClockInAlert) {
                        Alert(
                            title: Text("Clock In"),
                            message: Text("Are you sure you want to clock in?"),
                            primaryButton: .default(Text("Yes"), action: {
                                viewModel.clockIn()
                            }),
                            secondaryButton: .cancel()
                        )
                    }

                    ForEach(viewModel.tasks.indices, id: \.self) { index in
                        TaskItem(task: $viewModel.tasks[index]) {
                            viewModel.markTaskAsDone(at: index)
                        }
                    }
                    
                    TaskItem(
                        task: .constant(TaskDTO(
                            id: 0,
                            title: "Clock Out",
                            requiresImage: false,
                            isDone: viewModel.shift.assignedUser(for: viewModel.currentUserId)?.clockOutTime != nil,
                            time: viewModel.shift.assignedUser(for: viewModel.currentUserId)?.clockOutTime?.formatted(date: .omitted, time: .shortened)
                        ))
                    ) {
                        viewModel.showClockOutAlert = true
                    }
                    .alert(isPresented: $viewModel.showClockOutAlert) {
                        Alert(
                            title: Text("Clock Out"),
                            message: Text("Are you sure you want to clock out?"),
                            primaryButton: .default(Text("Yes"), action: {
                                viewModel.clockOut()
                            }),
                            secondaryButton: .cancel()
                        )
                    }
                }

                // Employee List
//                if shift.role.lowercased() == "head-trucker" {
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("Employees:")
//                            .font(.headline)
//                            .fontWeight(.bold)
//
//                        ForEach(shift.employees, id: \.id) { employee in
//                            EmployeeListItem(employee: employee)
//                        }
//                    }
//                }
            }
            .padding()
        }
        .background(AppColors.bg)
    }

//    private func markTaskAsDone(at index: Int) {
//        if !tasks[index].isDone {
//            tasks[index].isDone = true
//            progress += 1
//        }
//    }
}


struct Task: Identifiable {
    let id = UUID()
    let title: String
    let time: String?
    let requiresPhoto: Bool
    var isDone: Bool = false
}

struct Employee: Identifiable {
    let id = UUID()
    let initials: String
    let name: String
    let role: String
    let isClockedIn: Bool
    let clockInTime: String?
}

//#Preview(){
//    TaskScreen(shift: dummyShifts[0])
//}
