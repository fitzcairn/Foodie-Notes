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

struct EditableStandaloneWineNotesBox: View {
    let title:String
    let addTitle:String
    @Binding var text:String;
    @Binding var sameAsPrevious:Bool

    let onSave:() -> Void

    @State var showSheet:Bool = false;

    var body : some View {
        EditableWineSheetLayoutForNotes(title: title, text: $text, showSheet: $showSheet, sameAsPrevious: $sameAsPrevious, onSave:onSave) {
            if text.isEmpty {
                BarButtonTriggeringTextInput(title: title, addTitle: addTitle, text: $text, icon:"\u{e91d}", onSave:onSave)
            } else {
                HStack(alignment: .top, spacing: 0) {
                    FoodieText(text, Colors.TextStaticTextSecondary, size:14, weight:.semibold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(Colors.FillStaticFillPrimary)
                .cornerRadius(8)
                .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
                .shadow(color: Colors.ShadowEdge, radius: 4, x: 0, y: 0)
                .onTapGesture {
                    showSheet.toggle()
                }
            }
        }
    }
}


struct EditableWineSheetLayoutForNameAndImage<Content: View>: View {
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

struct EditableWineSheetLayoutForNotes<Content: View>: View {
    let title:String;
    
    @Binding var text:String;
    @Binding var showSheet:Bool;
    @Binding var sameAsPrevious:Bool

    @State private var newText:String = ""
    @State private var newSameAsPrevious:Bool = false

    var onSave:() -> Void = { }

    var itemNum:Int? = nil;
    
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
                        EditSheetComponentMainTextControl(title: title, text: $newText, itemNum:itemNum)
                    },
                    bottomButtons: {
                        EditSheetComponentBottomCheckboxAndButton(
                            checkbox: {
                                CheckboxButton(value: $newSameAsPrevious, text: "Shared with the previous course")
                            },
                            saveButton: {
                                EditSheetComponentSaveButton(
                                    disabledClosure: {
                                        text == newText && sameAsPrevious == newSameAsPrevious
                                    },
                                    action: {
                                        text = newText
                                        sameAsPrevious = newSameAsPrevious
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
                    newSameAsPrevious = sameAsPrevious
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
        EditableWineSheetLayoutForNameAndImage(title:"What was the name of this pairing?", text: $pairing.name, picture: $pairing.picture, showSheet: $showSheet, onSave:onSave) {
            BarButton(icon: icon, text: text, action: {
                pairing.notes = "";
                showSheet.toggle()
            })
        }
    }
}

