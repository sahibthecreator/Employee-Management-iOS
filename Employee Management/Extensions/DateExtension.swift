//
//  Date.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 26/11/2024.
//

import Foundation

extension Date {
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: self)
    }
    
    var isToday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(self)
    }
}

extension DateFormatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"  // ISO 8601
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}
