//
//  EditableRatingView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/11/24.
//

import SwiftUI

struct RatingView : View {
    let rating:Int?
    static let maximumRating = 5
    
    static func image(for number: Int, score: Int, size:CGFloat = 16, padding:CGFloat = -4) -> FoodieIcon {
        if number > score {
            FoodieIcon("\u{e925}", Colors.IconActionEmpty, size:size, padding:padding)
        } else {
            FoodieIcon("\u{e924}", Colors.IconActionSelected, size:size, padding:padding)
        }
    }
    
    var body: some View {
        let rating = rating ?? 0;
        HStack {
            ForEach(1..<RatingView.maximumRating + 1, id: \.self) { number in
                RatingView.image(for: number, score:rating)
            }
        }
    }
}

struct EditableRatingView<Content: View>: View {
    let title:String;
    @Binding var rating: Int
    let onSave:() -> Void
    @ViewBuilder let content: Content;
    
    var body : some View {
        EditableRatingSheetLayout(title:title, rating:$rating, onSave:onSave) {
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

private struct EditableRatingSheetLayout<Content: View>: View {
    let title:String;
    @Binding var rating: Int
    let onSave:() -> Void
    @ViewBuilder let content: Content;
    
    @State var showSheet:Bool = false;
    @State var newRating:Int = 0;
        
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
                        ratingFieldControl
                    },
                    bottomView: {
                        EditSheetComponentBottomSingleButton(
                            saveButton: {
                                EditSheetComponentSaveButton() {
                                    rating = newRating
                                    onSave()
                                    showSheet.toggle()
                                }
                            }
                        )
                    }
                )
                .onAppear() {
                    newRating = rating;
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
                                newRating = number
                            }, label: {
                                RatingView.image(for: number, score:newRating, size:32, padding:0)
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
