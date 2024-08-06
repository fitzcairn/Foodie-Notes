//
//  MealListSearchBox.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/6/24.
//

import SwiftUI

struct MealListSearchBox: View {
    @State var inputText:String = "";
    
    var prompt:String = "Search"
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
        VStack {
            Spacer()
                .frame(height:24)
            
            HStack {
                FoodieIcon("\u{e926}", Colors.TextActionTextAction)
                
                Spacer()
                    .frame(width:26)
                
                HStack(alignment: .center, spacing: 8) {
                    FoodieIcon("\u{e921}", Colors.TextActionTextAction)

                    TextField("", text:$inputText, prompt: promptText, axis:.vertical)
                        .onChange(of: inputText) {
                            onChangeClosure()
                        }
                        .font(
                          Font.custom("Nunito", size: 16)
                            .weight(.semibold)
                        )
                        .lineLimit(1)
                    
                    FoodieIcon("\u{e92a}", Colors.TextActionTextAction)
                        .onTapGesture {
                            inputText = ""
                        }
                }
                .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48, alignment: .leading)
                .cornerRadius(80)
                .overlay(
                    RoundedRectangle(cornerRadius: 80)
                        .inset(by: 0.75)
                        .stroke(Colors.BorderStaticBorderSecondary, lineWidth: 1.5)
                )
                
                Spacer()
                    .frame(width:26)
                
                FoodieIcon("\u{e923}", Colors.TextActionTextAction)
            }
            
            Spacer()
                .frame(height:16)
        }
        .padding(.horizontal, 24)
    }
}
