//
//  NotesViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import SwiftUI

//  All views related to notes.
struct NotesViews {
    // Display a note in a section
    struct NotesSection: View {
        let title: String;
        let note: String;

        var body: some View {
            Section(header: Text(title)) {
                NotesView(note:note)
            }
        }
    }


    // Display a note
    struct NotesView: View {
        let note: String;
        
        var body: some View {
            Text(note);
        }
    }

    // Notes edit embedded in a standalone session
    struct NotesEditSection: View {
        let title:String;

        var body: some View {
            Section(header: Text(title)) {
                NotesEditView()
            }
        }
    }
    
    // Notes edit view
    struct NotesEditView: View {
        @State var inputText:String = ""

        var body: some View {
            ZStack {
                if inputText.isEmpty {
                    HStack {
                        Text("Tap to Add Note")
                            .opacity(0.2)
                            .padding(.horizontal, 15)
                        Spacer()
                    }
                }
                HStack(alignment: .top) {
                    TextEditor(text: $inputText)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 6)
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
                    .padding(.trailing, 4)
                    .padding(.top, 6)
                }
                .buttonStyle(.plain)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
            .padding(.horizontal, -15)
        }
    }
}

