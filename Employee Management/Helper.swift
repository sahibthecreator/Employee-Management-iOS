//
//  Helper.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 07/01/2025.
//

import Foundation
import SwiftUI

func availabilityDotColor(for availability: Availability) -> Color {
    switch availability.status {
    case "unavailable":
        return .red
    case "partial":
        return .orange
    default:
        return .green
    }
}
