//
//  EditableRatingView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/11/24.
//

import SwiftUI

struct EditableRatingView<Content: View>: View {
    let title:String;
    @Binding var rating: Int
    let onSave:() -> Void;
    let content: Content;
    
    init(_ title:String, rating:Binding<Int>, onSave: @escaping () -> Void, @ViewBuilder _ content: () -> Content) {
        self.title = title;
        self._rating = rating;
        self.onSave = onSave;
        self.content = content()
    }
    
    var body : some View {
        EditableRatingComponent(title, $rating, onSave) {
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

private struct EditableRatingComponent<Content: View>: View {
    let title:String;
    @Binding var inputRating: Int
    let onSave:() -> Void;
    let content: Content;
    
    @State var showSheet:Bool = false;
    @State var editRating:Int
    
    init(_ title:String, _ inputRating:Binding<Int>, _ onSave: @escaping () -> Void, @ViewBuilder _ content: () -> Content) {
        self.title = title;
        self._inputRating = inputRating;
        self.onSave = onSave;
        self.content = content()
        self._editRating = State.init(initialValue: inputRating.wrappedValue)
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
                        ratingFieldControl
                    },
                    saveButton: {
                        LargeActionRedButton(icon:"\u{e905}") {
                            inputRating = editRating
                            onSave()
                            showSheet.toggle()
                        }
                    }
                )
                .onAppear() {
                    editRating = inputRating;
                }
            }
    }
    
    private var ratingFieldControl: some View {
        VStack(alignment: .leading) {
            FoodieText(title, Colors.TextStaticTextSecondary, size:16, weight:.semibold)
                .padding(8)
            
            VerticalSpace(8)
            
            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center) {
                    ForEach(1..<RatingView.maximumRating + 1, id: \.self) { number in
                        Button(
                            action: {
                                editRating = number
                            }, label: {
                                RatingView.image(for: number, score:editRating, size:32, padding:0)
                                    .padding(0)
                            }
                        )
                        conditionalSpacer(number)
                    }
                }
                .buttonStyle(.plain)
                .padding(0)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, minHeight: 64, maxHeight: 64, alignment: .leading)
        }
    }
    
    @ViewBuilder private func conditionalSpacer(_ num:Int)  -> some View {
        if (num < RatingView.maximumRating) {
            Spacer()
        } else {
            EmptyView()
        }
    }
}
