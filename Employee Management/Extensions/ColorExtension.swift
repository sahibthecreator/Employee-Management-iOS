//
//  ColorExtension.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 06/01/2025.
//

import Foundation
import SwiftUI

extension Color {
    
    static let primary: Color = Color(hex: "662C83")
    
    static let secondary: Color = Color(hex: "E8468E")
    
    static let tertiary: Color = Color(hex: "F29FA8")
    
    static let primaryText: Color = Color(hex: "0D1829")
    
    static let secondaryText: Color = Color(hex: "445668")
    
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
