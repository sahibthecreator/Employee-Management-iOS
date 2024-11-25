//
//  CalendarViewModel.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 25/11/2024.
//

import Foundation

class CalendarViewModel: ObservableObject {
    @Published var selectedTab: Int = 0 // 0: My Schedule, 1: Upcoming Events
    @Published var shifts: [Shift] = []
    @Published var events: [Event] = []

    init() {
        // Simulate data fetching
        loadShifts()
        loadEvents()
    }

    func loadShifts() {
        shifts = [
            Shift(title: "Vegan Summer Festival", location: "Prinses 202, Utrecht", date: "SEP 24, 2024", time: "07:00 – 15:00", role: "Trucker", teammates: ["AZ", "BR", "SZ", "+3"], isDraft: false),
            Shift(title: "Kebab Festival", location: "Haarlemplein, Amsterdam", date: "SEP 26, 2024", time: "07:00 – 15:00", role: "Building crew", teammates: ["AZ", "BR", "SZ", "+3"], isDraft: true),
            Shift(title: "Donner Festival", location: "Dam 132, Utrecht", date: "SEP 30, 2024", time: "08:00 – 17:00", role: "Trucker", teammates: ["AZ", "BR", "SZ", "+3"], isDraft: false)
        ]
    }

    func loadEvents() {
        events = [
            Event(title: "Music Fest", location: "Central Park, Utrecht", date: "SEP 24, 2024", time: "19:00 – 23:00", isDraft: false),
            Event(title: "Food Carnival", location: "Downtown, Amsterdam", date: "SEP 25, 2024", time: "12:00 – 20:00", isDraft: true)
        ]
    }
}

// Data Models
struct Shift {
    let title: String
    let location: String
    let date: String
    let time: String
    let role: String
    let teammates: [String]
    let isDraft: Bool?
}

struct Event {
    let title: String
    let location: String
    let date: String
    let time: String
    let isDraft: Bool?
}
