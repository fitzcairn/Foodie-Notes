//
//  MealListView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI

// View the list of meals.
// This is effectively the main view.
struct MealListView: View {
    // Model is "owned" by this view.
    @StateObject var viewModel : AppViewModel;
        
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.getMeals()) { meal in
                    MealItem(meal:meal)
                }
                .onDelete(perform: remove)
            }
            .listStyle(.plain)
            .navigationBarBackButtonHidden()
            .navigationBarItems(
                leading: Text("Meals")
                    .font(.system(size:36, weight: .bold)),
                trailing: NavigationLink(destination: MealCreateOrEditView(mealId:nil)) {
                    Image(systemName: "plus")
                        .resizable()
                        .padding(6)
                        .frame(width: 24, height: 24)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                })
        }
        .searchable(text: $viewModel.filter, placement: .navigationBarDrawer(displayMode: .always), prompt: "Type to Filter")
        .searchSuggestions {
            Text("SwiftUI").searchCompletion("SwiftUI")
            Text("iOS 15").searchCompletion("iOS 15")
        }
    }
    
    var background: some View {
        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
        
    func remove(at offsets: IndexSet) {
        // TODO: Implement delete
    }
    
}

// MARK: - Element Views

struct MealItem: View {
    @EnvironmentObject private var viewModel:AppViewModel;
    let meal:AppModel.Meal;
    
    var body: some View {
        HStack {
            Image(systemName: viewModel.getOrAddPickedPictureFor(meal).src)
                .resizable()
                .frame(width: 64.0, height: 64.0)
            NavigationLink(destination: MealView(mealId: meal.id)) {
                VStack(alignment: .leading) {
                    Text(meal.venue.name)
                        .bold()
                    Text(meal.notes)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(8)
            }
        }
    }
}


#Preview {
    MealListView(viewModel:AppViewModel(numTestMeals:5))
}
