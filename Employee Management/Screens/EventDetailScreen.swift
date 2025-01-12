//
//  EventDetailScreen.swift
//  Employee Management
//
//  Created by Sahib Zulfigar on 09/01/2025.
//

import Foundation
import SwiftUI

struct EventDetailScreen: View {
    let event: EventDTO
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading){
                    Text(event.venue)
                        .font(.primary(size: 30))
                        .foregroundColor(.primaryText)
                    
                    Text(event.startTime.formatted(date: .complete, time: .omitted))
                        .font(.secondary(size:17))
                        .foregroundColor(.secondaryText)
                }
                DetailRow(title: "Address", content: event.address)
                DetailRow(title: "Description", content: event.description)
                DetailRow(title: "Scheduled For", content: "\(event.startTime.formatted(date: .omitted, time: .shortened)) - \(event.endTime.formatted(date: .omitted, time: .shortened))", warning: event.status == "draft")
                DetailRow(title: "Additional Information", content: event.note ?? "No additional information")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .background(AppColors.bg)
        .onAppear(){
            print(event.status)
        }
    }
}

