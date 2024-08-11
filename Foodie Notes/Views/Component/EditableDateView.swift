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
    let onSave:() -> Void;
    let content: Content;
    
    init(_ title:String, date:Binding<Date>, onSave: @escaping () -> Void, @ViewBuilder _ content: () -> Content) {
        self.title = title;
        self._date = date;
        self.onSave = onSave;
        self.content = content()
    }
    
    var body : some View {
        EditableDateComponent(title, $date, onSave) {
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

private struct EditableDateComponent<Content: View>: View {
    let title:String;
    @Binding var inputDate:Date;
    let onSave:() -> Void;
    let content: Content;
    
    @State var showSheet:Bool = false;
    @State var editDate:Date;
    
    init(_ title:String, _ inputDate:Binding<Date>, _ onSave: @escaping () -> Void, @ViewBuilder _ content: () -> Content) {
        self.title = title;
        self._inputDate = inputDate;
        self.onSave = onSave;
        self.content = content()
        self._editDate = State.init(initialValue: inputDate.wrappedValue)
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
                    },
                    editView: {
                        dateFieldControl
                    },
                    saveButton: {
                        LargeActionRedButton(icon:"\u{e905}") {
                            inputDate = editDate
                            onSave()
                            showSheet.toggle()
                        }
                    }
                )
                .onAppear() {
                    editDate = inputDate;
                }
            }
    }
    
    private var dateFieldControl: some View {
        VStack(alignment: .leading) {
            FoodieText(title, Colors.TextStaticTextSecondary, size:16, weight:.semibold)
                .padding(8)
            
            VerticalSpace(8)
            
            HStack(alignment: .center, spacing: 4) {
                HStack {
                    FoodieText(editDate.formatted(date: .abbreviated, time: .omitted), Colors.TextStaticTextPrimary, size:18, weight:.semibold)
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
                        selection: $editDate,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .blendMode(.destinationOver)
                }
                
                HStack {
                    FoodieText(editDate.formatted(date: .omitted, time: .shortened), Colors.TextStaticTextPrimary, size:18, weight:.semibold)
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
                        selection: $editDate,
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
