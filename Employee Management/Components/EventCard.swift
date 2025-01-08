//
//  EventCard.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 08/01/2025.
//

import Foundation
import SwiftUI

struct EventCard: View {
    let event: EventDTO

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading) {
                    Text(event.venue)
                        .font(.headline)
                        .fontWeight(.bold)
                    Text(event.address)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(event.startTime.formattedDate())
                        .font(.primary(size: 16))
                        .fontWeight(.bold)
                        Text("\(event.startTime.formattedTime()) - \(event.endTime.formattedTime())")
                            .font(.secondary(size: 14))
                            .foregroundColor(event.status != "Planned" ? .red : .gray)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}
