//
//  RatingSubViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import SwiftUI

    
struct RatingView : View {
    let rating:Int?
    
    var body: some View {
        let rating = rating ?? 0;
        HStack {
            ForEach(1..<RatingEditView.maximumRating + 1, id: \.self) { number in
                RatingEditView.image(for: number, score:rating)
            }
        }
    }
}

struct RatingEditView : View {
    @Binding var rating: Int
    
    static let maximumRating = 5
    
    static func image(for number: Int, score: Int) -> FoodieIcon {
        if number > score {
            FoodieIcon("\u{e925}", Colors.IconActionEmpty, size:16, padding:-4)
        } else {
            FoodieIcon("\u{e924}", Colors.IconActionSelected, size:16, padding:-4)
        }
    }
    
    var body: some View {
        HStack {
            ForEach(1..<RatingEditView.maximumRating + 1, id: \.self) { number in
                Button(
                    action: {
                        rating = number
                    }, label: {
                        RatingEditView.image(for: number, score:rating)
                    }
                )
            }
        }
        .buttonStyle(.plain)
    }
}
