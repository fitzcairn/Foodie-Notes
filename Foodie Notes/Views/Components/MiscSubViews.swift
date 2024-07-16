//
//  MiscViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/30/24.
//

import SwiftUI

// Pop an error.
struct ErrorDialog : View {
    let text:String
    @State var showingAlert:Bool = true;
    
    var body: some View {
        EmptyView()
            .alert("Error", isPresented: $showingAlert) {
                Text(text)
                Button("OK", role: .cancel) {
                    showingAlert = false;
                }
            }
    }
}


// Wrap a form with scroll-friendly space at the bottom.
struct ScrollForm<Content: View>: View {
    @ViewBuilder let content: Content
    
    var body: some View {
        Form {
            content
            Section(header:Text("")){ }
                .padding(.bottom, 20)
        }
    }
}


struct SecondaryAddButtonImage : View {
    var body: some View {
        Image(systemName: "plus.circle")
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundColor(.gray)
            .padding(.trailing, -20)
    }
}

struct StyledTextField : View {
    @Binding var inputText:String;

    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                TextField("Tap to Add/Edit", text:$inputText, axis:.vertical)
                    .padding(.horizontal, 4)
                    .padding(.top, 3)
                    .padding(.bottom, 1)
                Spacer()
                Button(
                    action: {
                        self.inputText = ""
                    },
                    label: {
                        Image(systemName: "x.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color.gray)
                    }
                )
                .padding(.trailing, 2)
                .padding(.top, 2)
                .padding(.bottom, 2)
            }
            .buttonStyle(.plain)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 0.5)
            )
        }
    }
}

// All views related to showing and editing dates.
struct DateViews {
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
