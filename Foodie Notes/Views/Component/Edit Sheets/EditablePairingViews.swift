//
//  EditablePairingViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/13/24.
//

import SwiftUI

struct PairingBox<Content:View> : View {
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

struct EditableStandalonePairingNotesBox: View {
    let title:String
    let addTitle:String
    @Binding var pairing:BeveragePairing;

    let onSave:() -> Void

    @State var showSheet:Bool = false;

    var body : some View {
        EditablePairingSheetLayoutForNotes(title:title, pairing:$pairing, showSheet:$showSheet, onSave:onSave) {
            if pairing.notes.isEmpty {
                BarButton(icon: "\u{e91d}", text: addTitle, action: {
                    showSheet.toggle()
                })
            } else {
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
}

struct EditablePairingSheetComponentNameAndImageControl: View {
    let title:String;
    let icon:String;
    @Binding var picture:Picture?
    @Binding var info:BeverageLookupInfo

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                SingleImageCarousel(picture: $picture, mutable:true)
                    .padding(.trailing, 8)

                RecogninzePairingView(info:$info, picture:$picture)
            }

            Divider()
                .padding(.horizontal, -50) // hack
                .padding(.top, 8)

            VerticalSpace(16)
            
            EditSheetComponentMainTextControl(title:title, text: $info.name)
            
            Spacer()
        }
    }
}

struct EditablePairingSheetLayoutForNameAndImage<Content: View>: View {
    let title:String;
    
    @Binding var pairing:BeveragePairing;
    @Binding var showSheet:Bool;

    var onSave:() -> Void = {}
    
    @State private var newInfo:BeverageLookupInfo = BeverageLookupInfo()
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
                        SmallClearButton(disabled: { newInfo.name.isEmpty }) {
                            newInfo = BeverageLookupInfo()
                        }
                    },
                    showDivider: false,
                    mainView: {
                        EditablePairingSheetComponentNameAndImageControl(
                            title: title,
                            icon: "\u{e913}",
                            picture: $newPicture,
                            info: $newInfo
                        )
                    },
                    bottomButtons: {
                        EditSheetComponentBottomSingleButton(
                            saveButton: {
                                EditSheetComponentSaveButton(
                                    disabledClosure: {
                                        (pairing.info.name == newInfo.name && pairing.picture == newPicture) || newInfo.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                    },
                                    action: {
                                        pairing.info.name = newInfo.name.trimmingCharacters(in: .whitespacesAndNewlines)
                                        pairing.info.url = newInfo.url;
                                        pairing.picture = newPicture
                                        showSheet.toggle()
                                        onSave()
                                    }
                                )
                            }
                        )
                    }
                )
                .onAppear() {
                    newInfo = pairing.info
                    newPicture = pairing.picture
                }
            }
    }
}

struct EditablePairingSheetLayoutForNotes<Content: View>: View {
    let title:String;
    
    @Binding var pairing:BeveragePairing;
    @Binding var showSheet:Bool;
    
    @State private var newNotes:String = ""
    @State private var newSameAsPrevious:Bool = false

    var onSave:() -> Void = { }
    
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
                        SmallClearButton(disabled: { newNotes.isEmpty }) {
                            newNotes = ""
                            newSameAsPrevious = false;
                        }
                    },
                    mainView: {
                        EditSheetComponentMainTextControl(title: title, text: $newNotes)
                    },
                    bottomButtons: {
                        EditSheetComponentBottomCheckboxAndButton(
                            checkbox: {
                                CheckboxButton(value: $newSameAsPrevious, text: "Shared with previous course")
                            },
                            saveButton: {
                                EditSheetComponentSaveButton(
                                    disabledClosure: { pairing.notes == newNotes && pairing.sameAsPrevious == newSameAsPrevious
                                    },
                                    action: {
                                        pairing.notes = newNotes.trimmingCharacters(in: .whitespacesAndNewlines)
                                        pairing.sameAsPrevious = newSameAsPrevious
                                        showSheet.toggle()
                                        onSave()
                                    }
                                )
                            }
                        )
                    }
                )
                .onAppear() {
                    newNotes = pairing.notes
                    newSameAsPrevious = pairing.sameAsPrevious
                }
            }
    }
}

struct PairingAddImageBarButton: View {
    let text:String;
    var icon:String = "\u{e913}";
    @Binding var pairing:BeveragePairing
    var onSave:() -> Void = {}

    @State var showSheet:Bool = false;
    
    var body : some View {
        EditablePairingSheetLayoutForNameAndImage(title:"What was the name of this pairing?", pairing: $pairing, showSheet: $showSheet, onSave:onSave) {
            BarButton(icon: icon, text: text, action: {
                pairing.notes = "";
                showSheet.toggle()
            })
        }
    }
}

