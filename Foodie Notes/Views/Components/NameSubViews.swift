//
//  NameSubViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import SwiftUI

// Name of something
struct NameSubViews {
    private static let title:String = "Name"
  
    struct NameViewSection : View {
        let name:String;
        
        var body: some View {
            Section(header: Text(title)) {
                HStack {
                    Text(name)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                }
            }
        }
    }

    struct NameEditSection : View {
        @Binding var name: String
        
        var body: some View {
            Section(header: Text(title)) {
                HStack {
                    NameEditView(name: $name)
                }
            }
        }
    }
    
    struct NameEditView : View {
        @Binding var name: String
        
        var body: some View {
            HStack(alignment: .top) {
                TextField("", text: $name, prompt: Text("Tap to Add"))
                    .padding(.horizontal, 4)
                    .padding(.vertical, 6)
                Spacer()
                Button(
                    action: {
                        self.name = ""
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
    }
}
