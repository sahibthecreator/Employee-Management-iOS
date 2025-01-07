//
//  FontExtension.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 07/01/2025.
//

import Foundation
import SwiftUI

extension Font {
    static func primary(size: CGFloat = 28, relativeTo textStyle: Font.TextStyle = .title) -> Font {
        Font.custom("Mindset-Regular", size: size, relativeTo: textStyle)
    }
    
    static func secondary(size: CGFloat = 16, relativeTo textStyle: Font.TextStyle = .body) -> Font {
        Font.custom("Colby", size: size, relativeTo: textStyle)
    }
}
