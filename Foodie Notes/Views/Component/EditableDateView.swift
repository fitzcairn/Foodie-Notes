//
//  EditableDateView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/11/24.
//

import SwiftUI

struct EditableDateView<Content: View>: View {
    let title:String;
    @Binding var date:Date;
    let onSave:() -> Void
    @ViewBuilder let content: Content;
    
    var body : some View {
        EditableDateSheetLayout(title:title, date:$date, onSave:onSave) {
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

private struct EditableDateSheetLayout<Content: View>: View {
    let title:String;
    @Binding var date:Date;
    let onSave:() -> Void
    
    @State var showSheet:Bool = false;
    @State var newDate:Date = Date()

    @ViewBuilder let content: Content;

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
                    },
                    mainView: {
                        EditSheetComponentMainDateControl(title:title, date:$newDate)
                    },
                    bottomButtons: {
                        EditSheetComponentBottomSingleButton() {
                            EditSheetComponentSaveButton(
                                disabledClosure: { newDate == date },
                                action: {
                                    date = newDate
                                    onSave()
                                    showSheet.toggle()
                                }
                            )
                        }
                    }
                )
            }
            .onAppear() {
                newDate = date;
            }
    }
}

struct EditSheetComponentMainDateControl: View {
    let title:String;
    @Binding var date:Date;
    
    var body: some View {
        VStack(alignment: .leading) {
            FoodieText(title, Colors.TextStaticTextSecondary, size:16, weight:.semibold)
                .padding(8)
            
            VerticalSpace(8)
            
            HStack(alignment: .center, spacing: 4) {
                HStack {
                    FoodieText(date.formatted(date: .abbreviated, time: .omitted), Colors.TextStaticTextPrimary, size:18, weight:.semibold)
                        .padding(8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .background(Colors.FillStaticFillPrimary)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .inset(by: 0.5)
                                .stroke(Colors.BorderStaticBorderTertiary, lineWidth: 1)
                        )
                }
                .overlay {
                    DatePicker(
                        "",
                        selection: $date,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .blendMode(.destinationOver)
                }
                
                HStack {
                    FoodieText(date.formatted(date: .omitted, time: .shortened), Colors.TextStaticTextPrimary, size:18, weight:.semibold)
                        .padding(8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .background(Colors.FillStaticFillPrimary)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .inset(by: 0.5)
                                .stroke(Colors.BorderStaticBorderTertiary, lineWidth: 1)
                        )
                }
                .overlay {
                    DatePicker(
                        "",
                        selection: $date,
                        in: ...Date(),
                        displayedComponents: .hourAndMinute
                    )
                    .blendMode(.destinationOver)
                }
                
            }
            .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48, alignment: .leading)
        }
    }
}
