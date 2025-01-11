//
//  EventCard.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 07/01/2025.
//

import Foundation
import SwiftUI

struct EventCard: View {
    let event: EventDTO
    
    var body: some View {
        NavigationLink(destination: EventDetailScreen(event: event)) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(event.venue)
                            .font(.primary(size: 17))
                            .foregroundColor(.primaryText)
                        Text(event.address)
                            .font(.secondary(size: 15))
                            .foregroundColor(.secondaryText)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(event.startTime.formatted(date: .abbreviated, time: .omitted))
                            .font(.primary(size: 17))
                            .foregroundColor(.secondaryText)
                        Text("\(event.startTime.formatted(date: .omitted, time: .shortened)) - \(event.endTime.formatted(date: .omitted, time: .shortened))")
                            .font(.secondary(size: 15))
                            .foregroundColor(event.status == "draft" ? .red : .gray)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
