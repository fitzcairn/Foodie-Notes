//
//  MiscViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/30/24.
//

import SwiftUI



struct EditButtonImage : View {
    var body: some View {
        ZStack {
            Circle()
                //.strokeBorder(lineWidth:2)
                .foregroundColor(.gray)
                .opacity(0.5)
                .frame(width: 24, height: 24)
            Image(systemName: "pencil")
                .resizable()
                .frame(width: 14, height: 14)
                .foregroundColor(.white)
        }
    }
}


struct AddButtonImage : View {
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
                .padding(.top,2)
            }
            .buttonStyle(.plain)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 0.5)
            )
        }
    }
}

struct SaveButton: View {
    let actionFunc:(() -> Void)
    
    var body: some View {
        Button(
            action: {
                // TODO: trigger model write.
                print("Save tapped")
                actionFunc()
            },
            label: {
                Text("Save")
                    .frame(minWidth: 0, maxWidth: 200)
                    .font(.system(size: 18))
                    .padding()
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white, lineWidth: 2)
                    )
            })
        .background(Color.blue)
        .cornerRadius(25)
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
        let date: Date;
        let dateFormatter: DateFormatter;
        
        init(_ date: Date) {
            self.date = date
            self.dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
        }
                
        var body: some View {
            Section(title) {
                HStack {
                    Text(dateFormatter.string(from: date))
                }
            }
        }
    }
}
