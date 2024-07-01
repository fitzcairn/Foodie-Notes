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
                    MealItem(meal:meal, viewModel: viewModel)
                }
                .onDelete(perform: remove)
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
    let meal:AppModel.Meal;
    @ObservedObject var viewModel:AppViewModel;
    
    init(meal: AppModel.Meal, viewModel: AppViewModel) {
        self.meal = meal
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            Image(systemName: "sun.max.fill")
                .resizable()
                .frame(width: 64.0, height: 64.0)
            // TODO: implement passing in the meal for edit, or nil for create.
            NavigationLink(destination: MealView(mealId: meal.id, viewModel: viewModel)) {
                VStack(alignment: .leading) {
                    Text(meal.getVenue().name)
                        .bold()
                    Text(meal.notes ?? "")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(8)
            }
        }
    }
}


#Preview {
    MealListView(viewModel: AppViewModel(numTestMeals:5))
}
