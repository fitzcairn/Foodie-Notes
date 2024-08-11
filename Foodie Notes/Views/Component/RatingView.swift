//
//  RatingSubViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
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

// TODO: DELETE
struct RatingEditView : View {
    @Binding var rating: Int
    
    var body: some View {
        HStack {
            ForEach(1..<RatingView.maximumRating + 1, id: \.self) { number in
                Button(
                    action: {
                        rating = number
                    }, label: {
                        RatingView.image(for: number, score:rating)
                    }
                )
            }
        }
        .buttonStyle(.plain)
    }
}
