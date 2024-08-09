//
//  EditableTextRow.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/9/24.
//

import SwiftUI



// TODO: Make a protocol and a viewmodel implementation per control type to power this.
// We're going to need lots of different edit sheets, so write a viewmodel to generalize.
struct EditSheet {
    
    @Binding var showSheet:Bool;
    
    var body: some View {
        Text("hi")
    }
}
    


struct EditableTextRow<Content: View>: View {
    let content: Content;
    var title:String = "The title of this text control."
    

    
    @State var showSheet:Bool = false;
    @State var inputText:String = "";
    @FocusState private var setFocus:Bool;
    
    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    private var textFieldPrompt: Text {
        Text("Start writing...")
          .font(
            Font.custom("Nunito", size: 18)
                .weight(.semibold)
          )
          .foregroundColor(Colors.TextStaticTextPrompt)
    }
    
    var textFieldControl: some View {
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
    
    var body: some View {
        
        // TODO: Sheet for editing.
        
        VStack(alignment: .trailing, spacing: 4) {
            content
        }
        .padding(12)
        .background(Colors.FillStaticFillPrimary)
        .cornerRadius(8)
        .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
        .shadow(color: Colors.ShadowEdge, radius: 4, x: 0, y: 0)
        .onTapGesture {
            showSheet.toggle()
        }
        .sheet(isPresented: $showSheet) {
            VStack {
                
                // Top buttons
                HStack(alignment: .top) {
                    HStack(alignment: .center, spacing: 4) {
                        SmallActionBackButton(icon: "\u{e900}") {
                            showSheet.toggle()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .frame(width: 48, height: 48, alignment: .center)
                    .cornerRadius(80)
                    
                    Spacer()
                    
                    SmallClearButton(disabled: inputText.isEmpty) {
                        inputText = ""
                    }
                }
                .padding(16)
                
                
                VStack {
                    
                    // Edit fields here.
                    // TODO: how much of this is generalizable?
                    textFieldControl
                    
                }
                .padding(.horizontal, 25)
                
                
                Spacer()
                
                // Button
                VStack(alignment: .trailing, spacing: 16) {
                    HStack {
                        Spacer ()
                        LargeActionRedButton(icon:"\u{e905}", disabled:inputText.isEmpty) {
                            showSheet.toggle()
                        }
                    }
                }
                .padding(.horizontal, 32)
                .padding(.top, 24)
                .padding(.bottom, 32)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 1, green: 0.98, blue: 0.96).opacity(0), location: 0.00),
                            Gradient.Stop(color: Color(red: 1, green: 0.99, blue: 0.96), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 1)
                    )
                )
            }
            .onAppear {
                setFocus = true;
            }
            .presentationDetents([.fraction(0.95)])
            .presentationContentInteraction(.scrolls)
            .presentationBackground(alignment: .bottom) {
                Color(Colors.BackgroundBgPrimary)
                    .cornerRadius(24)
            }
        }
    }
}
