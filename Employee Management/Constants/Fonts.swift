//
//  Fonts.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 18/11/2024.
//

import Foundation
import SwiftUI

struct AppFonts {
    static func primary(size: CGFloat = 28) -> Font {
            Font.custom("Mindset-Regular", size: size, relativeTo: .title)
        }
}

// extension is possible
extension Font {
    static func primary(size: CGFloat = 28, relativeTo textStyle: Font.TextStyle = .title) -> Font {
        Font.custom("Mindset-Regular", size: size, relativeTo: textStyle)
    }
    
    static func secondary(size: CGFloat = 28, relativeTo textStyle: Font.TextStyle = .body) -> Font {
        Font.custom("Mindset-Bold", size: size, relativeTo: textStyle)
    }
}
