//
//  MichelinSubViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/18/24.
//

import SwiftUI

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
                            .padding(.leading, -4)
                    } else {
                        Image(rating.imgName)
                            .resizable()
                            .frame(width: michelinDim, height: michelinDim)
                            .padding(.leading, -4)                    }
                }
            }
            .tag(rating)
        }
        return imageView;
    }
    
    struct MichelinNameView: View {
        let name:String?
        let rating:Michelin?
        
        var body: some View {
            if let rating = rating {
                Text(Image(rating.imgName + "_sm")) +  Text(" " + (name ?? ""))
            }
            else {
                Text(name ?? "")
            }
        }
    }
    
    struct MichelinEditView: View {
        @Binding var selection:Michelin?
        
        var body: some View {
            HStack {
                ForEach(Michelin.allCases, id: \.rawValue) { rating in
                    Button {
                        if selection == rating {
                            selection = nil;
                        } else {
                            selection = rating;
                        }
                    }
                    label: {
                        if selection == rating {
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
            //.padding(.top, 10)
        }
    }
    
}
