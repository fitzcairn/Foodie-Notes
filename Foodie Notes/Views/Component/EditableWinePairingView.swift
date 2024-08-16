//
//  EditableWinePairingView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/13/24.
//

import SwiftUI

struct WineBox<Content:View> : View {
    @ViewBuilder let content:Content;
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            content
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .inset(by: 0.75)
                .stroke(Colors.BorderStaticBorderTertiary, lineWidth: 1.5)
        )
    }
}

struct EditableWineSheetLayout<Content: View>: View {
    let title:String;
    
    @Binding var text:String;
    @Binding var picture:Picture?
    @Binding var showSheet:Bool;

    var onSave:() -> Void = {}
    
    @State private var newText:String = ""
    @State private var newPicture:Picture? = nil

    @ViewBuilder let content: Content;

    var body: some View {
        content
            .sheet(isPresented: $showSheet) {
                EditSheetView(
                    topLeftButton: {
                        SmallActionBackButton(icon: "\u{e900}") {
                            showSheet.toggle()
                        }
                    },
                    topRightButton: {
                        SmallClearButton(disabled: { newText.isEmpty }) {
                            newText = ""
                        }
                    },
                    mainView: {
                        EditSheetComponentMainTextAndSingleImageControl(
                            title: title,
                            icon: "\u{e913}",
                            text: $newText,
                            picture: $newPicture
                        )
                    },
                    bottomButtons: {
                        EditSheetComponentBottomSingleButton(
                            saveButton: {
                                EditSheetComponentSaveButton(
                                    disabledClosure: {
                                        text == newText && picture == newPicture
                                    },
                                    action: {
                                        text = newText
                                        picture = newPicture
                                        showSheet.toggle()
                                        onSave()
                                    }
                                )
                            }
                        )
                    }
                )
                .onAppear() {
                    newText = text
                    newPicture = picture
                }
            }
    }
}

struct BarButtonTriggeringAddWinePhoto: View {
    let text:String;
    var icon:String = "\u{e913}";
    @Binding var pairing:BeveragePairing
    var onSave:() -> Void = {}

    @State var showSheet:Bool = false;
    
    var body : some View {
        EditableWineSheetLayout(title:"What was the name of this pairing?", text: $pairing.name, picture: $pairing.picture, showSheet: $showSheet, onSave:onSave) {
            BarButton(icon: icon, text: text, action: {
                pairing.notes = "";
                showSheet.toggle()
            })
        }
    }
}

