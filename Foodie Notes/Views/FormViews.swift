//
//  FormViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/30/24.
//

import SwiftUI


struct SaveButton: View {
    var body: some View {
        Button(
            action: {
                print("Save tapped")
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


struct NotesSection: View {
    let title:String;

    var body: some View {
        Section(header: Text(title)) {
            NotesView()
        }
    }
}


struct NotesView: View {
    @State private var inputText:String = ""

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8.0)
                .strokeBorder(lineWidth:1)
                .foregroundColor(.gray)
            ZStack {
                if inputText.isEmpty {
                    Text("Add a Note")
                        .opacity(0.2)
                }
                
                TextEditor(text: $inputText)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, -15)
    }
}


struct DatePickerSection: View {
    let prompt:String;

    @State var selectedDate: Date = Date()
    
    var body: some View {
        Section {
            DatePicker(
                prompt,
                selection: $selectedDate,
                in: Date()...,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.compact)
        }
    }
}

struct PictureAndAnnotationSection: View {
    let title:String;
    
    var body: some View {
        Section(header: Text(title)) {
            HStack {
                VStack(alignment:.center) {
                    Text("\n\nTODO: Photo Carousel\n\n")
                    Button(
                        action: {
                            print("Add Photo!")
                        },
                        label: {
                            Image(systemName: "photo.badge.plus")
                                .font(.system(size:30))
                                .minimumScaleFactor(0.01)
                                .aspectRatio(1, contentMode: .fit)
                                .foregroundColor(.blue)
                        })
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
                NotesView()
            }
        }
    }
}
