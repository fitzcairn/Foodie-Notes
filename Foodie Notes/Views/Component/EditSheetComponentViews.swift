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
    var itemNum:Int? = nil;
    
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
            .fixedSize(horizontal: false, vertical: true)
    }

    var body: some View {
        VStack(alignment: .leading) {
            FoodieText(title, Colors.TextStaticTextSecondary, size:16, weight:.semibold)
                .padding(8)
            
            VerticalSpace(16)
            
            textField
            
            if let courseNumber = itemNum {
                OfferCourseNameSuggestions(text: $text, numCourses: courseNumber)
            }
        }
    }
}

struct EditSheetComponentMainTextAndMultiImageControl: View {
    let title:String;
    @Binding var text:String;
    @Binding var pictures:[Picture]
    
    var body: some View {
        VStack(alignment: .leading) {
            EditSheetComponentMainTextControl(title:title, text: $text)
            
            VerticalSpace(16)
            
            FlexibleImageGrid(pictures: $pictures, mutable: true)
            
            Spacer()
        }
    }
}

struct EditSheetComponentMainTextAndSingleImageControl: View {
    let title:String;
    let icon:String;
    @Binding var text:String;
    @Binding var picture:Picture?
    
    var body: some View {
        VStack(alignment: .leading) {
            SingleImageCarousel(picture: $picture, mutable:true)

            VerticalSpace(16)
            
            EditSheetComponentMainTextControl(title:title, text: $text)
            
            Spacer()
        }
    }
}

struct EditSheetComponentBottomCheckboxAndButton<SaveButton: View, Checkbox: View>: View {
    @ViewBuilder let checkbox:Checkbox
    @ViewBuilder let saveButton:SaveButton

    var body: some View {
        VStack(alignment: .trailing, spacing: 16) {
            HStack {
                checkbox
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
        LargeActionRedButton(icon:"\u{e905}", disabled:disabledClosure(), action: action, dim:48, iconSize:24)
    }
}
