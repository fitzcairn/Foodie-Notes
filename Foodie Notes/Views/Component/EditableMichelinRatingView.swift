//
//  EditableMichelinRatingView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/11/24.
//

import SwiftUI


struct MichelinStarView: View {
    let rating:Michelin?
    
    var body: some View {
        HStack {
            if let rating = rating {
                FoodieIcon(rating.imgName, Colors.IconActionSelected, size:18, padding:0)
            }
            else {
                EmptyView()
            }
        }
    }
}

struct EditableMichelinRatingView<Content: View>: View {
    let title:String;
    @Binding var rating: Michelin
    var onSave:() -> Void = { }
    @ViewBuilder let content: Content;
    
    var body : some View {
        EditableMichelinRatingComponent(title:title, rating:$rating, onSave:onSave) {
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

private struct EditableMichelinRatingComponent<Content: View>: View {
    let title:String;
    @Binding var rating: Michelin
    var onSave:() -> Void = { }

    @State var showSheet:Bool = false;
    @State var newRating:Michelin = .none
 
    @ViewBuilder let content: Content;
 
    private let michelinRatings:[Michelin] = Michelin.allCases
    
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
                    bottomButtons: {
                        EditSheetComponentBottomSingleButton() {
                            EditSheetComponentSaveButton() {
                                rating = newRating
                                onSave()
                                showSheet.toggle()
                            }
                        }
                    }
                )
            }
            .onAppear() {
                newRating = rating
            }
    }
    
    private var ratingFieldControl: some View {
        VStack(alignment: .leading) {
            FoodieText(title, Colors.TextStaticTextSecondary, size:16, weight:.semibold)
                .padding(8)
            
            VStack(alignment: .center, spacing: 4) {
                ForEach(michelinRatings, id: \.rawValue) { rating in
                    MichelinButton(label: rating, rating: $newRating)
                }
                .buttonStyle(.plain)
                .padding(0)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 16)
        }
    }
}

private struct MichelinButton: View {
    let label:Michelin;
    @Binding var rating: Michelin
    
    var body: some View {
        Button(
            action: {
                rating = label;
            },
            label:  {
                HStack {
                    VerticalSpace(32)
                }
                .padding(.vertical, 12)
                .padding(.leading, 16)
                .padding(.trailing, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        )
        .buttonStyle(MichelinButtonStyle(label: label, isSelected: rating == label))
    }
}

private struct MichelinButtonStyle: ButtonStyle {
    let label:Michelin;
    let isSelected:Bool;
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(isSelected ? Colors.FillStaticFillPrimary : configuration.isPressed ? Colors.FillActionFillActionPressedSubtle : Colors.BackgroundBgPrimary)
            .cornerRadius(8)
            .overlay() {
                HStack {
                    FoodieText(label.displayName, isSelected ? Colors.TextActionTextActionSelected : Colors.TextStaticTextPrimary, size:12, weight:.bold)
                    Spacer()
                    FoodieIcon(label.imgName, isSelected ? Colors.TextActionTextActionSelected : configuration.isPressed ? Colors.TextStaticTextPrimary : Colors.MichelinIconInactive, size:24, padding:0)
                }
                .padding(.vertical, 12)
                .padding(.leading, 16)
                .padding(.trailing, 12)
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.5)
                    .stroke(configuration.isPressed ? Colors.FillActionFillActionPressedSubtle : Colors.BorderStaticBorderSubtle, lineWidth: 1)
                    .shadow(color: isSelected ? Colors.ShadowMed : .clear, radius: 8, x: 0, y: 8)
                    .shadow(color: isSelected ? Colors.ShadowEdge : .clear, radius: 4, x: 0, y: 0)
            }

    }
}

