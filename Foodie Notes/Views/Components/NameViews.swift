//
//  NameViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import SwiftUI

// Name of something
struct NameViews {
    private static let title:String = "Name"

    struct NameAndImageView : View {
        private let name:String
        private let image:String
        
        init(name: String, image: String) {
            self.name = name
            self.image = image
        }
        
        var body: some View {
            HStack {
                Image(systemName: image)
                    .resizable()
                    .frame(width: 64.0, height: 64.0)
                Text(name)
                    .padding(.leading, 10)
                Spacer()
            }
        }
    }
    
    struct NameAndImageEditView : View {
        // TODO: Needs to be in viewmodel.
        @Binding var name: String
        // TODO: Needs to be in viewmodel.
        @Binding var image: String?
        
        var body: some View {
            HStack {
                PictureViews.EditablePictureView(image: image)
                NameEditView(name:$name)
                Spacer()
            }
        }
    }
    
    struct NameViewSection : View {
        // TODO: Needs to be in viewmodel.
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
        // TODO: Needs to be in viewmodel.
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
        // TODO: Needs to be in viewmodel.
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
