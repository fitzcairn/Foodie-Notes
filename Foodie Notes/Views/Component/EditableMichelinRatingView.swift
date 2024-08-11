//
//  EditableMichelinRatingView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/11/24.
//

import SwiftUI

struct EditableMichelinRatingView<Content: View>: View {
    let title:String;
    @Binding var rating: Michelin?
    let onSave:() -> Void;
    let content: Content;
    
    init(_ title:String, rating:Binding<Michelin?>, onSave: @escaping () -> Void, @ViewBuilder _ content: () -> Content) {
        self.title = title;
        self._rating = rating;
        self.onSave = onSave;
        self.content = content()
    }
    
    var body : some View {
        EditableMichelinRatingComponent(title, $rating, onSave) {
            VStack(alignment: .trailing, spacing: 4) {
                content
            }
            .padding(12)
            .background(Colors.FillStaticFillPrimary)
            .cornerRadius(8)
            .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
            .shadow(color: Colors.ShadowEdge, radius: 4, x: 0, y: 0)
        }
        .onAppear() {
            print(rating)
        }
    }
}

private struct EditableMichelinRatingComponent<Content: View>: View {
    let title:String;
    @Binding var inputRating: Michelin?
    let onSave:() -> Void;
    let content: Content;
    
    @State var showSheet:Bool = false;
    @State var editRating:Michelin
    
    // TODO: Update once conversion complete on old data.
    let michelinRatings:[Michelin] = [.none, .plateIcon, .bibGourmandIcon, .oneStarIcon, .twoStarIcon, .threeStarIcon] //.allCases
    
    
    init(_ title:String, _ inputRating:Binding<Michelin?>, _ onSave: @escaping () -> Void, @ViewBuilder _ content: () -> Content) {
        self.title = title;
        self._inputRating = inputRating;
        self.onSave = onSave;
        self.content = content()
        self._editRating = State.init(initialValue: inputRating.wrappedValue ?? .none)
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
                    editRating = inputRating ?? .none;
                }
            }
    }
    
    private var ratingFieldControl: some View {
        VStack(alignment: .leading) {
            FoodieText(title, Colors.TextStaticTextSecondary, size:16, weight:.semibold)
                .padding(8)
            
            
            VStack(alignment: .center, spacing: 4) {
                ForEach(michelinRatings, id: \.rawValue) { rating in
                    MichelinButton(label: rating, rating: $editRating)
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

