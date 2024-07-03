//
//  NotesSubViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import SwiftUI

//  All views related to notes.
struct NotesSubViews {
    // Display a note in a section
    struct NotesSection: View {
        let title: String;
        let note: String;

        var body: some View {
            Section(header: Text(title)) {
                NotesView(inputText:note)
            }
        }
    }


    // Display a note
    struct NotesView: View {
        var inputText:String;
       
        var body: some View {
            Text(inputText);
        }
    }

    // Notes edit embedded in a standalone session
    struct NotesEditSection: View {
        let title:String;
        @Binding var inputText:String;

        var body: some View {
            Section(header: Text(title)) {
                StyledTextField(inputText: $inputText)
            }
        }
    }
}

