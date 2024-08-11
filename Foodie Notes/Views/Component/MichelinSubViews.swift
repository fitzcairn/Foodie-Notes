//
//  MichelinSubViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/18/24.
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


struct MichelinSubViews {
    private static let michelinDim:CGFloat = 18;
    
    private static func getImage(_ rating:Michelin) -> some View {
        var imageView: some View {
            HStack {
                if (!rating.imgName.isEmpty) {
                    if let numStars = Int(rating.imgName.prefix(1)) {
                        Image(rating.imgName)
                            .resizable()
                            .frame(width: CGFloat(numStars) * michelinDim, height: michelinDim)
                    } else {
                        Image(rating.imgName)
                            .resizable()
                            .frame(width: michelinDim, height: michelinDim)
                    }
                }
            }
            .tag(rating)
            .padding(.leading, -7)
            .padding(.trailing, -3)
        }
        return imageView;
    }
        
    struct MichelinNameView: View {
        let name:String?
        let rating:Michelin?
        
        var body: some View {
            HStack {
                if let rating = rating {
                    Text(Image(rating.imgName + "_sm")) +  Text(" " + (name ?? ""))
                        .font(.system(size:18, weight: .bold))
                }
                else {
                    Text(name ?? "")
                        .font(.system(size:18, weight: .bold))
                }
            }
            .padding(.top, 6)
        }
    }
    
    struct MichelinEditView: View {
        @Binding var selection:Michelin?
        @State var value:Michelin?
                
        var body: some View {
            HStack {
                ForEach(Michelin.allCases, id: \.rawValue) { rating in
                    Button {
                        if value == rating {
                            value = nil;
                        } else {
                            value = rating;
                        }
                    }
                    label: {
                        if value == rating {
                            HStack {
                                Image(systemName: "checkmark.square")
                                    .resizable()
                                    .frame(width: michelinDim, height: michelinDim)
                                    .foregroundColor(Color.red)
                                getImage(rating)
                            }
                        } else {
                            HStack {
                                Image(systemName: "square")
                                    .resizable()
                                    .frame(width: michelinDim, height: michelinDim)
                                    .foregroundColor(Color.gray)
                                getImage(rating)
                            }
                            .opacity(0.6)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .onAppear() {
                value = selection;
            }
            .onChange(of: value) {
                selection = value;
            }
        }
    }
    
}
