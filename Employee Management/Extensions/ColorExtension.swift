//
//  ColorExtension.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 06/01/2025.
//

import Foundation
import SwiftUI

extension Color {
    static func randomAppColor() -> Color {
        let colors = [
            AppColors.primary,      // Original Primary
            AppColors.secondary,    // Original Secondary
            AppColors.tertiary,     // Original Tertiary
            Color(hex: "662C83"),   // Extra Original
            Color(hex: "9B59B6"),   // Soft Purple
            Color(hex: "8E44AD"),   // Deep Violet
            Color(hex: "F39CBB"),   // Soft Pink
            Color(hex: "D988BC"),   // Mauve
            Color(hex: "D354A1")    // Vibrant Magenta
        ]
        return colors.randomElement() ?? AppColors.primary
    }
}
