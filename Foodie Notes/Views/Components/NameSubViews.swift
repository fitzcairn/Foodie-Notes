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
                    StyledTextField(inputText: $name)
                }
            }
        }
    }
}
