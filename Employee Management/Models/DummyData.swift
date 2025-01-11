//
//  DummyData.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 26/11/2024.
//

import Foundation

func createDate(year: Int, month: Int, day: Int) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    return Calendar.current.date(from: components)!
}

//// Dummy Data
//let dummyShifts = [
//    Shift(
//        title: "Vegan Summer Festival",
//        location: "Prinses 202, Utrecht",
//        date: createDate(year: 2024, month: 12, day: 10),
//        time: "07:00 – 15:00",
//        role: "Trucker",
//        teammates: ["AZ", "BR", "SZ", "+3"],
//        isDraft: false,
//        employees: [employees[0], employees[1]]
//    ),
//    Shift(
//        title: "Kebab Festival",
//        location: "Haarlemplein, Amsterdam",
//        date: createDate(year: 2024, month: 11, day: 26),
//        time: "07:00 – 15:00",
//        role: "Building crew",
//        teammates: ["AZ", "BR", "SZ", "+3"],
//        isDraft: true,
//        employees: [employees[0], employees[1]]
//    ),
//    Shift(
//        title: "Donner Festival",
//        location: "Dam 132, Utrecht",
//        date: createDate(year: 2024, month: 12, day: 14),
//        time: "08:00 – 17:00",
//        role: "Trucker",
//        teammates: ["AZ", "BR", "SZ", "+3"],
//        isDraft: false,
//        employees: [employees[0], employees[1]]
//    )
//]
//
//let dummyEvents = [
//    Event(
//        title: "Music Fest",
//        location: "Central Park, Utrecht",
//        date: createDate(year: 2024, month: 12, day: 24),
//        time: "19:00 – 23:00",
//        isDraft: false
//    ),
//    Event(
//        title: "Food Carnival",
//        location: "Downtown, Amsterdam",
//        date: createDate(year: 2024, month: 12, day: 28),
//        time: "12:00 – 20:00",
//        isDraft: true
//    )
//]
//
//let dummyTasks: [Task] = [
//    Task(title: "Clock In", time: "7:01", requiresPhoto: false),
//    Task(title: "Sell 20kg of vegan kebab", time: nil, requiresPhoto: false),
//    Task(title: "Deliver to stand 3B and 5D", time: nil, requiresPhoto: false),
//    Task(title: "Pack the remaining", time: nil, requiresPhoto: false),
//    Task(title: "Take a picture of cash desk", time: nil, requiresPhoto: true),
//    Task(title: "Clock Out", time: nil, requiresPhoto: false)
//]
//
//let employees: [Employee] = [
//    Employee(initials: "BB", name: "Me", role: "Trucker", isClockedIn: true, clockInTime: "06:55"),
//    Employee(initials: "WM", name: "Willem", role: "Team Lead", isClockedIn: true, clockInTime: "08:00")
//]
