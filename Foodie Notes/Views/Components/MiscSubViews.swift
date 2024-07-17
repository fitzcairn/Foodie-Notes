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

struct StyledTitleText : View {
    let text:String;
    
    init(_ text:String) {
        self.text = text
    }
    
    var body : some View {
        Text(text)
            .font(.system(size:36, weight: .bold))
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
