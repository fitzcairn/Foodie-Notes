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

    typealias Meal = AppModel.Meal  

    @State var needRefresh:Bool = true;

    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(viewModel.getMeals(), id: \.self) { meal in
                        MealItem(mealId:meal.id)
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

// MARK: - Element Views

struct MealItem: View {
    @EnvironmentObject private var viewModel:AppViewModel;
    let mealId:String;
    
    var body: some View {
        // Should never get a miss on lookup here.  But for some reason, we do whenever something is deleted.
        if let meal = viewModel.getMealFor(mealId) {
            HStack {
                Image(systemName: viewModel.getOrAddPickedPictureFor(meal).src)
                    .resizable()
                    .frame(width: 64.0, height: 64.0)
                NavigationLink(destination: MealView(mealId: meal.id)) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(meal.venue.name)
                                .bold()
                            Spacer()
                            LocationSubViews.RatingViews.RatingView(rating:meal.venue.rating)
                        }
                        Text(meal.notes)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(8)
                }
            }
        } else {
            EmptyView()
        }
    }
}


/*
 NavigationStack {
     List {
         ForEach(viewModel.getMeals(), id: \.self) { meal in
             MealItem(mealId:meal.id)
         }
         .onDelete() { at in
             remove(at:at, meals:viewModel.getMeals())
         }
     }
     .listStyle(.plain)
     .navigationBarBackButtonHidden()
     .navigationBarItems(
         leading: Text("Meals")
             .font(.system(size:36, weight: .bold)),
         trailing: NavigationLink(destination: MealCreateOrEditView(
             needRefresh:$needRefresh,
             mealId:nil)) {
             Image(systemName: "plus")
                 .resizable()
                 .padding(6)
                 .frame(width: 24, height: 24)
                 .background(Color.blue)
                 .clipShape(Circle())
                 .foregroundColor(.white)
         }
         .simultaneousGesture(TapGesture().onEnded {
             _ = viewModel.addMeal(nil)
         })
     )
 */
