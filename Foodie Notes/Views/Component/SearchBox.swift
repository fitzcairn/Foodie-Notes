//
//  SearchBox.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/12/24.
//

import SwiftUI

struct SearchBox: View {
    var prompt:String = "Search"
    @Binding var searchText:String
    @Binding var isFocused:Bool
    var assumeFocus:Bool = false;
    var onChangeClosure:(() -> Void) = {}
    var onSubmitClosure:(() -> Void) = {}

    
    @FocusState private var focused;
    
    var promptText: Text {
        Text(prompt)
          .font(
            Font.custom("Nunito", size: 16)
              .weight(.semibold)
          )
          .foregroundColor(Colors.TextStaticTextPrompt)
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            FoodieIcon("\u{e921}", Colors.TextActionTextAction)
            
            TextField("", text:$searchText, prompt: promptText, axis:.vertical)
                .font(
                    Font.custom("Nunito", size: 16)
                        .weight(.semibold)
                )
                .foregroundColor(Colors.TextStaticTextPrimary)
                .lineLimit(1)
                .focused($focused, equals: true)
                .submitLabel(.search)
                .autocorrectionDisabled()
                .onChange(of: focused) {
                    isFocused = focused
                }
                .onChange(of: searchText) {
                    onChangeClosure()
                }
                .onSubmit(of: .search) {
                    print("submit!")
                    onSubmitClosure()
                    focused = false;
                }
                .onAppear {
                    if (assumeFocus) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.focused = true
                        }
                    }
                }

            FoodieIcon("\u{e92a}", Colors.TextActionTextAction)
                .onTapGesture {
                    searchText = ""
                }
                .opacity(searchText.isEmpty ? 0 : 1)
        }
        .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48, alignment: .leading)
        .cornerRadius(80)
        .overlay(
            RoundedRectangle(cornerRadius: 80)
                .inset(by: 0.75)
                .stroke(focused ? Colors.BorderActionBorderActionInvert : Colors.BorderStaticBorderSecondary, lineWidth: 1.5)
        )
    }
}
