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
    var onChangeClosure:(() -> Void) = {}
    
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
                .onChange(of: searchText) {
                    onChangeClosure()
                }
                .font(
                    Font.custom("Nunito", size: 16)
                        .weight(.semibold)
                )
                .foregroundColor(Colors.TextStaticTextPrimary)
                .lineLimit(1)
            
            FoodieIcon("\u{e92a}", Colors.TextActionTextAction)
                .onTapGesture {
                    searchText = ""
                }
        }
        .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48, alignment: .leading)
        .cornerRadius(80)
        .overlay(
            RoundedRectangle(cornerRadius: 80)
                .inset(by: 0.75)
                .stroke(Colors.BorderStaticBorderSecondary, lineWidth: 1.5)
        )
    }
}
