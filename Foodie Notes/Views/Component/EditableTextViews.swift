//
//  EditableTextViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/9/24.
//

import SwiftUI



struct EditableTextBoxRow: View {
    let title:String
    var text:String = ""
    
    var body : some View {
        EditableTextComponent(title) {
            HStack(alignment: .top, spacing: 4) {
                FoodieText(text, Colors.TextStaticTextSecondary, size:14, weight:.semibold)
            }
            .padding(8)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}



struct EditableStandaloneTextBox: View {
    let title:String
    var text:String = ""
    
    var body : some View {
        EditableTextComponent(title) {
            HStack(alignment: .top, spacing: 0) {
                FoodieText(text, Colors.TextStaticTextSecondary, size:14, weight:.semibold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Colors.FillStaticFillPrimary)
            .cornerRadius(8)
            .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
            .shadow(color: Colors.ShadowEdge, radius: 4, x: 0, y: 0)
        }
    }
}


struct EditableTextRow<Content: View>: View {
    let title:String;
    let content: Content;
    
    init(_ title:String, @ViewBuilder _ content: () -> Content) {
        self.title = title;
        self.content = content()
    }
    
    var body : some View {
        EditableTextComponent(title) {
            VStack(alignment: .trailing, spacing: 4) {
                content
            }
            .padding(12)
            .background(Colors.FillStaticFillPrimary)
            .cornerRadius(8)
            .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
            .shadow(color: Colors.ShadowEdge, radius: 4, x: 0, y: 0)
        }
    }
}

struct EditableTextComponent<Content: View>: View {
    let title:String;
    let content: Content;
    
    @State var showSheet:Bool = false;
    @State var inputText:String = "";
    @FocusState private var setFocus:Bool;
    
    init(_ title:String, @ViewBuilder _ content: () -> Content) {
        self.title = title;
        self.content = content()
    }
    
    var body: some View {
        content
        .onTapGesture {
            showSheet.toggle()
        }
        .sheet(isPresented: $showSheet) {
            EditSheetView(
                topLeftButton: {
                    SmallActionBackButton(icon: "\u{e900}") {
                        showSheet.toggle()
                    }
                },
                topRightButton: {
                    SmallClearButton(disabled: inputText.isEmpty) {
                        inputText = ""
                    }
                },
                editView: {
                    textFieldControl
                },
                saveButton: {
                    LargeActionRedButton(icon:"\u{e905}", disabled:inputText.isEmpty) {
                        showSheet.toggle()
                    }
                }
            )
        }
    }
    
    private var textFieldPrompt: Text {
        Text("Start writing...")
          .font(
            Font.custom("Nunito", size: 18)
                .weight(.semibold)
          )
          .foregroundColor(Colors.TextStaticTextPrompt)
    }
    
    private var textFieldControl: some View {
        VStack(alignment: .leading) {
            FoodieText(title, Colors.TextStaticTextSecondary, size:16, weight:.semibold)
                .padding(8)

            VerticalSpace(16)
            
            TextField("", text:$inputText, prompt: textFieldPrompt, axis:.vertical)
                .font(
                  Font.custom("Nunito", size: 18)
                      .weight(.semibold)
                )
                .foregroundColor(Colors.TextStaticTextPrimary)
                .padding(8)
                .focused($setFocus)

        }
    }
}
