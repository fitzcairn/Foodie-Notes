//
//  EditSheetComponentViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/13/24.
//

import SwiftUI

struct EditSheetComponentMainTextControl: View {
    let title:String;
    @Binding var text:String;
    var assumesFocus:Bool = true;
    
    @FocusState private var focus:Bool;

    private var textFieldPrompt: Text {
        Text("Start writing...")
            .font(
                Font.custom("Nunito", size: 18)
                    .weight(.semibold)
            )
            .foregroundColor(Colors.TextStaticTextPrompt)
    }
    
    private var textField: some View {
        TextField("", text:$text, prompt: textFieldPrompt, axis:.vertical)
            .font(
                Font.custom("Nunito", size: 18)
                    .weight(.semibold)
            )
            .focused($focus)
            .foregroundColor(Colors.TextStaticTextPrimary)
            .padding(8)
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline:.now()){
                    focus = assumesFocus
                }
            }
    }

    var body: some View {
        VStack(alignment: .leading) {
            FoodieText(title, Colors.TextStaticTextSecondary, size:16, weight:.semibold)
                .padding(8)
            
            VerticalSpace(16)
            
            textField
        }
    }
}

struct EditSheetComponentMainTextAndMultiImageControl<SaveButton: View>: View {
    let title:String;
    @Binding var text:String;
    @Binding var pictures:[Picture]
    @ViewBuilder let saveButton:SaveButton
    
    var body: some View {
        VStack(alignment: .leading) {
            EditSheetComponentMainTextControl(title:title, text: $text)
            
            VerticalSpace(16)
            
            ImageCarouselHorizontal(pictures: $pictures, mutable: true)
            
            Spacer()
            
            HStack {
                MultiImagePickerButton(pictures: $pictures)
                
                Spacer()
                
                saveButton
            }
        }
    }
}

struct EditSheetComponentMainTextAndSingleImageControl<SaveButton: View>: View {
    let title:String;
    let icon:String;
    @Binding var text:String;
    @Binding var picture:Picture?
    @ViewBuilder let saveButton:SaveButton
    
    var body: some View {
        VStack(alignment: .leading) {           
            EditSheetComponentMainTextControl(title:title, text: $text)
                        
            VerticalSpace(16)
            
            SingleImageCarousel(picture: $picture, mutable:true)

            Spacer()
            
            HStack {
                MultiImagePickerButton(
                    pictures: Binding<[Picture]>(
                        get: { if picture == nil { [] } else { [picture!] } },
                        set: { picture = $0.first! }
                    ),
                    icon:icon,
                    limit: 1
                )
                
                Spacer()
                
                saveButton
            }
        }
    }
}

struct EditSheetComponentBottomSingleButton<SaveButton: View>: View {
    @ViewBuilder let saveButton:SaveButton
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 16) {
            HStack {
                Spacer ()
                saveButton
            }
            .padding(.bottom, 0)
            .padding(.trailing, -8)
        }
        .padding(.horizontal, 32)
        .padding(.top, 24)
    }
}

struct EditSheetComponentSaveButton: View {
    var disabledClosure:() -> Bool =  { false }
    let action:() -> Void
    
    var body: some View {
        LargeActionRedButton(icon:"\u{e905}", disabled:disabledClosure(), action: action)
    }
}
