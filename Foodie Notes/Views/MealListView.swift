//
//  MealListView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI

// View the list of meals.
struct MealListView: View {
    @Binding var searchText: String;

    // TODO: replace with view model
    @State private var meals = [["Sushi Jiro", "It was a delicious meal."],
                                ["Manresa", "Too bad it closed."],
                                ["St. Lawrence Restaurant", "Yummy side dishes!"]]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(meals, id: \.self) { meal in
                    MealItem(meal[0], meal[1])
                }
                .onDelete(perform: removeMeal)
            }
            .listStyle(.plain)
            .navigationBarBackButtonHidden()
            .navigationBarItems(
                leading: Text("Meals")
                    .font(.system(size:36, weight: .bold)),
                trailing: NavigationLink(destination: MealCreateOrEditView()) {
                    Image(systemName: "plus")
                        .resizable()
                        .padding(6)
                        .frame(width: 24, height: 24)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                })
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Type to Filter")
        .searchSuggestions {
            Text("SwiftUI").searchCompletion("SwiftUI")
            Text("iOS 15").searchCompletion("iOS 15")
        }
    }
    
    var background: some View {
        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
    
    
    func removeMeal(at offsets: IndexSet) {
        // TODO: Implement delete
    }
    
}

// MARK: - Element Views

struct MealItem: View {
    // TODO: Change to model ASAP.
    let venue: String
    let review: String;
    
    init(_ venue: String, _ review: String) {
        self.venue = venue
        self.review = review
    }
    
    var body: some View {
        HStack {
            Image(systemName: "sun.max.fill")
                .resizable()
                .frame(width: 64.0, height: 64.0)
            // TODO: implement passing in the meal for edit, or nil for create.
            NavigationLink(destination: MealView()) {
                VStack(alignment: .leading) {
                    Text(venue)
                        .bold()
                    Text(review)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(8)
            }
        }
    }
}


#Preview {
    MealListView(searchText: .constant(""))
}
