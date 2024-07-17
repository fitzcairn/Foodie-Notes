//
//  DateSubViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/17/24.
//

import SwiftUI

// All views related to showing and editing dates.
struct DateSubViews {
    private static let title:String = "When Enjoyed"
    private static let prompt:String = "Date/Time:"
    
    struct DatePickerSection: View {
        @Binding var selectedDate:Date
        
        var body: some View {
            Section(title) {
                DatePicker(
                    prompt,
                    selection: $selectedDate,
                    in: ...Date(),
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.compact)
                .bold()
            }
        }
    }
    
    struct DateSection: View {
        let date: Date?
        let dateFormatter: DateFormatter;
        
        init(_ date: Date?) {
            self.date = date
            self.dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
        }
                
        var body: some View {
            Section(title) {
                HStack {
                    Text(dateFormatter.string(from: date ?? Date()))
                }
            }
        }
    }
}
