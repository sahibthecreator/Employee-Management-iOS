//
//  Colors.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 14/11/2024.
//

import Foundation
import SwiftUI

struct AppColors {
    static let primary = Color(hex: "662C83")
    static let secondary = Color(hex: "E8468E")
    static let tertiary = Color(hex: "F29FA8")
    static let dark = Color(hex: "0D1829")
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0
        scanner.scanHexInt64(&hexNumber)
        let r = Double((hexNumber & 0xff0000) >> 16) / 255
        let g = Double((hexNumber & 0x00ff00) >> 8) / 255
        let b = Double(hexNumber & 0x0000ff) / 255
        self.init(red: r, green: g, blue: b)
    }
}
