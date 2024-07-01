//
//  ComponentViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/30/24.
//

import SwiftUI


struct SaveButton: View {
    var body: some View {
        Button(
            action: {
                // TODO: trigger model write.
                print("Save tapped")
            },
            label: {
                Text("Save")
                    .frame(minWidth: 0, maxWidth: 200)
                    .font(.system(size: 18))
                    .padding()
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white, lineWidth: 2)
                    )
            })
            .background(Color.blue)
            .cornerRadius(25)
    }
}


// All views related to showing and editing dates.
struct DateViews {
    private static let title:String = "When Enjoyed"
    private static let prompt:String = "Date/Time:"

    
    struct DatePickerSection: View {
        @State var selectedDate: Date = Date()
        
        var body: some View {
            Section(title) {
                DatePicker(
                    prompt,
                    selection: $selectedDate,
                    in: ...Date(),
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.compact)
                .bold()
            }
        }
    }
    
    struct DateSection: View {
        let date: Date;
        let dateFormatter: DateFormatter;
        
        init(_ date: Date) {
            self.date = date
            self.dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
        }
                
        var body: some View {
            Section(title) {
                HStack {
                    Text(dateFormatter.string(from: date))
                }
            }
        }
    }
}

// All views and logic related to Location
struct LocationViews {
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
        // TODO: Needs to be in viewmodel.
        @Binding var venue: String
        
        var body: some View {
            Section(header: Text(title)) {
                HStack {
                    NameViews.NameEditView(name:$venue)
                    Spacer()
                    RatingViews.RatingEditView(rating:.constant(0))
                }
            }
        }
    }
    
    //  All views and logic related to rating.
    struct RatingViews {
        // TODO: move to model
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
            // TODO: Needs to be in viewmodel.
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
                                print(number)
                            }, label: {
                                image(for: number, score:rating)
                                    .foregroundColor(number > rating ? offColor : onColor)
                            }
                        )
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}
