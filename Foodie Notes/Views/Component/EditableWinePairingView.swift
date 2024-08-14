//
//  EditableWinePairingView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/13/24.
//

import SwiftUI



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
                EditSheetViewNoBottom(
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
                            picture: $newPicture,
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

struct BarButtonTriggeringAddWinePairing: View {
    let title:String
    let addTitle:String
    @Binding var pairing:BeveragePairing
    var onSave:() -> Void = {}

    @State var showSheet:Bool = false;
    
    var body : some View {
        EditableWineSheetLayout(title:title, text: $pairing.notes, picture: $pairing.picture, showSheet: $showSheet, onSave:onSave) {
            BarButton(icon: "\u{e91d}", text: addTitle, action: {
                pairing.notes = "";
                showSheet.toggle()
            })
        }
    }
}

struct EditableWinePairingRow: View {
    let title:String
    let addTitle:String
    @Binding var pairing:BeveragePairing;
    var onSave:() -> Void = {}
    
    @State private var textFieldHeight: CGFloat = .zero
    @State var showSheet:Bool = false;
    
    var body : some View {
        EditableWineSheetLayout(title:title, text: $pairing.notes, picture: $pairing.picture, showSheet: $showSheet) {
            HStack(alignment: .top, spacing: 0) {
                FoodieText(pairing.notes, Colors.TextStaticTextSecondary, size:14, weight:.semibold)
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

struct EditableWinePairingView: View {
    @Binding var pairings:[BeveragePairing];
    var onSave:() -> Void = {}

    var body: some View {
        if (pairings.isEmpty) {
            EmptyView()
        } else {
            ForEach(Array(zip(pairings.indices, pairings)), id: \.0) { index, pairing in
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .center, spacing: 8) {
                        EditableStandaloneTextBox(title: "What was the name of this pairing?", addTitle: "Add wine name", text: $pairings[index].info.name, onSave:onSave)
                        
                        HStack(alignment: .center, spacing: 0) {
                            FoodieIcon("\u{e920}", Colors.TextActionTextAction, size:36, padding:0)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 0)
                        .cornerRadius(8)
                        .frame(maxHeight:.infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .inset(by: 0.75)
                                .stroke(Colors.BorderStaticBorderSecondary, lineWidth: 1.5)
                        )
                    }
                    .padding(0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    EditableWinePairingRow(title: "Any notes on this pairing?", addTitle: "Add notes", pairing:$pairings[index])
                    
                    HStack(alignment: .center, spacing: 8) {
                        VStack(alignment: .leading, spacing: 0) {
                            
                        }
                        .padding(8)
                        .frame(width: 24, height: 24, alignment: .topLeading)
                        
                        .cornerRadius(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .inset(by: 0.75)
                                .stroke(Colors.BorderActionBorderActionSubtle, lineWidth: 1.5)
                        )
                        
                        FoodieText("Shared with previous course", Colors.TextStaticTextSecondary, size:14, weight:.semibold)
                        
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cornerRadius(8)
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
    }
}
