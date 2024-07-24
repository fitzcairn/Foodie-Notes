//
//  RatingSubViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import SwiftUI

    //  All views and logic related to rating.
struct RatingSubViews {
    private static let maximumRating = 5
    
    private static let offImage = Image(systemName: "star")
    private static let onImage = Image(systemName: "star.fill")
    
    private static let offColor = Color.gray
    private static let onColor = Color.orange
    
    private static func image(for number: Int, score: Int) -> Image {
        if number > score {
            offImage
        } else {
            onImage
        }
    }
    
    struct RatingView : View {
        let rating:Int?
        
        var body: some View {
            let rating = rating ?? 0;
            HStack {
                ForEach(1..<maximumRating + 1, id: \.self) { number in
                    image(for: number, score:rating)
                        .foregroundColor(number > rating ? offColor : onColor)
                        .padding(.horizontal, -2)
                }
            }
        }
    }
    
    struct RatingEditView : View {
        @Binding var rating: Int
        
        var body: some View {
            HStack {
                ForEach(1..<maximumRating + 1, id: \.self) { number in
                    Button(
                        action: {
                            rating = number
                        }, label: {
                            image(for: number, score:rating)
                                .foregroundColor(number > rating ? offColor : onColor)
                                .padding(.horizontal, -2)
                        }
                    )
                }
            }
            .buttonStyle(.plain)
            .padding(.leading, 10)
        }
    }
}
