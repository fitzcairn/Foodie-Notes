//
//  LocationSubViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import SwiftUI

// All views and logic related to Location
struct LocationSubViews {
    private static let title:String = "Venue and Rating"
    
    struct LocationViewSection : View {
        let venue:String;
        let rating:Int;
        
        var body: some View {
            Section(header: Text(title)) {
                HStack {
                    Text(venue)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    Spacer()
                    RatingViews.RatingView(rating: rating)
                }
            }
        }
    }
    
    struct LocationEditSection : View {
        @Binding var venue: String
        @Binding var rating: Int

        
        var body: some View {
            Section(header: Text(title)) {
                HStack {
                    StyledTextField(inputText:$venue)
                    Spacer()
                    RatingViews.RatingEditView(rating:$rating)
                        .padding(.trailing, 15)
                }
            }
        }
    }
    
    //  All views and logic related to rating.
    struct RatingViews {
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
            let rating:Int;
            
            var body: some View {
                HStack {
                    ForEach(1..<maximumRating + 1, id: \.self) { number in
                        image(for: number, score:rating)
                            .foregroundColor(number > rating ? offColor : onColor)
                    }
                }
            }
        }
        
        struct RatingEditView : View {
            // TODO: Needs to be in viewmodel.
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
                            }
                        )
                    }
                }
                .buttonStyle(.plain)
                .padding(.leading, 10)
                .padding(.trailing, -15)
            }
        }
    }
}
