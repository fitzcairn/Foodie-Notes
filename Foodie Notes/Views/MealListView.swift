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
    @EnvironmentObject var viewModel:AppViewModel;

    @State var needRefresh:Bool = true;

    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(viewModel.model.mealsById.values.sorted(by: {$0.date > $1.date }), id: \.self) { meal in
                        HStack {
                            let pickedImage = meal.pickedImage
                            PictureSubViews.PictureView(picture:meal.pickedImage)
                            NavigationLink(destination: MealView(
                                needListRefresh: $needRefresh,
                                mealId: meal.id)
                            ) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(viewModel.getMealFor(meal.id)!.venue.name)
                                            .bold()
                                        Spacer()
                                        LocationSubViews.RatingViews.RatingView(rating:viewModel.getMealFor(meal.id)!.venue.rating)
                                    }
                                    Text(viewModel.getMealFor(meal.id)!.notes)
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                .padding(8)
                            }
                        }
                    }
                    .onDelete() { at in
                        remove(at:at, meals:viewModel.getMeals())
                    }
                }
                .listStyle(.plain)
                .navigationBarBackButtonHidden()
                .navigationBarItems(
                    leading: Text("Meals")
                        .font(.system(size:36, weight: .bold))
                )
                VStack {
                    Spacer()
                    NavigationLink(destination: MealCreateOrEditView(
                        needRefresh:$needRefresh,
                        mealId:nil)) {
                            PrimaryNewButtonImage()
                        }
                    .simultaneousGesture(TapGesture().onEnded {
                        _ = viewModel.addMeal(nil)
                    })
                }
            }
        }
        // TODO: Add filtering in V2!
        /*.searchable(text: $viewModel.filter, placement: .navigationBarDrawer(displayMode: .always), prompt: "Type to Filter")
         .searchSuggestions {
         Text("SwiftUI").searchCompletion("SwiftUI")
         Text("iOS 15").searchCompletion("iOS 15")
         }*/
    }
    
    var background: some View {
        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
        
    func remove(at offsets: IndexSet, meals:[Meal]) {
        print(offsets);
        for (index, meal) in meals.enumerated() {
            if offsets.contains(index) {
                viewModel.removeMeal(meal.id);
            }
        }
    }
}

