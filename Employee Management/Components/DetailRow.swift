//
//  DetailRow.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 08/01/2025.
//

import Foundation
import SwiftUI

struct DetailRow: View {
    var title: String
    var content: String
    var warning: Bool?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.secondary(size: 17))
                .foregroundColor(.secondaryText)
            HStack(spacing: 10) {
                Text(content)
                    .font(.secondary(size: 15))
                    .foregroundColor(warning == true ? .red : .secondaryText)
                if let warning = warning, warning {
                    Image("warning-icon")
                        .resizable()
                        .frame(width: 16, height: 16)
                }
            }
        }
    }
}
