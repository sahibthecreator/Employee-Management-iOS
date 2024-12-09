//
//  TaskScreen.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 09/12/2024.
//

import Foundation
import SwiftUI

struct TaskScreen: View {
    let shift: Shift
    @State private var tasks: [Task] = dummyTasks // Task list for the shift
    @State private var progress: Int = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 50) {
                // Shift Details
                VStack(alignment: .center, spacing: 5) {
                    Text(shift.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    HStack(spacing: 10) {
                        Image(systemName: "location.fill")
                            .foregroundColor(.gray)
                        Text(shift.location)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }

                    HStack(spacing: 10) {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.gray)
                        Text("\(shift.time)")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        Image(systemName: "clock.fill")
                            .foregroundColor(.gray)
                        Text(shift.role)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                }
                .frame(maxWidth: .infinity)

                // Task List
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("TASK LIST")
                            .font(.headline)
                            .fontWeight(.bold)
                        Spacer()
                        HStack {
                            CircularProgressView(progress: Double(progress) / Double(tasks.count))
                                .frame(width: 20)
                            Text("\(progress)/\(tasks.count) Complete")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                        
                    }

                    ForEach(tasks.indices, id: \.self) { index in
                        TaskItem(task: $tasks[index]) {
                            markTaskAsDone(at: index)
                        }
                    }
                }

                // Employee List
                if shift.role.lowercased() == "head-trucker" {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Employees:")
                            .font(.headline)
                            .fontWeight(.bold)

                        ForEach(shift.employees, id: \.id) { employee in
                            EmployeeListItem(employee: employee)
                        }
                    }
                }
            }
            .padding()
        }
    }

    private func markTaskAsDone(at index: Int) {
        if !tasks[index].isDone {
            tasks[index].isDone = true
            progress += 1
        }
    }
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

#Preview(){
    TaskScreen(shift: dummyShifts[0])
}
