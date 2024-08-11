//
//  EditableTextViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/9/24.
//

import SwiftUI



struct EditableImageAndTextBoxRow: View {
    let title:String
    let img:Picture?
    @Binding var text:String;
    let onSave:() -> Void;

    @State private var textFieldHeight: CGFloat = .zero
    
    var body : some View {
        HStack(alignment: .top, spacing: 10) {
            HStack(alignment: .center) {
                VariableHeightListPicture(picture: img)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .padding(4)
            }
            .frame(width:64, height: textFieldHeight)
            
            EditableTextComponent(title, $text, onSave) {
                HStack(alignment: .top, spacing: 4) {
                    FoodieText(text, Colors.TextStaticTextSecondary, size:14, weight:.semibold)
                }
                .padding(8)
                .frame(maxWidth: .infinity, minHeight:64, alignment: .topLeading)
                .background(heightReader)
                
                .onChange(of: text) {
                    print(textFieldHeight)
                }
            }
        }
        .frame(minHeight:64)
        .background(Colors.FillStaticFillPrimary)
        .cornerRadius(8)
        .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
        .shadow(color: Colors.ShadowEdge, radius: 4, x: 0, y: 0)
    }
    
      private var heightReader: some View {
          GeometryReader { proxy in
              let h = proxy.size.height
              Colors.FillStaticFillPrimary
                  .onChange(of: h, initial: true) { oldVal, newVal in
                      textFieldHeight = newVal
                  }
          }
      }
}



struct EditableStandaloneTextBox: View {
    let title:String
    @Binding var text:String;
    let onSave:() -> Void;
    
    var body : some View {
        EditableTextComponent(title, $text, onSave) {
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
    @Binding var text:String;
    let onSave:() -> Void;
    let content: Content;
    
    init(_ title:String, text:Binding<String>, onSave: @escaping () -> Void, @ViewBuilder _ content: () -> Content) {
        self.title = title;
        self._text = text;
        self.onSave = onSave;
        self.content = content()
    }
    
    var body : some View {
        EditableTextComponent(title, $text, onSave) {
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

private struct EditableTextComponent<Content: View>: View {
    let title:String;
    @Binding var text:String;
    let onSave:() -> Void;
    let content: Content;
    
    @State var showSheet:Bool = false;
    //@State var editText:String;
    
    // !! -------
    // TODO: Only save editText on save button
    // !! -------

    init(_ title:String, _ text:Binding<String>, _ onSave: @escaping () -> Void, @ViewBuilder _ content: () -> Content) {
        self.title = title;
        self._text = text;
        self.onSave = onSave;
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
                    SmallClearButton(disabled: text.isEmpty) {
                        text = ""
                    }
                },
                editView: {
                    textFieldControl
                },
                saveButton: {
                    LargeActionRedButton(icon:"\u{e905}", disabled:text.isEmpty) {
                        onSave()
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
            
            TextField("", text:$text, prompt: textFieldPrompt, axis:.vertical)
                .font(
                  Font.custom("Nunito", size: 18)
                      .weight(.semibold)
                )
                .foregroundColor(Colors.TextStaticTextPrimary)
                .padding(8)
        }
    }
}
