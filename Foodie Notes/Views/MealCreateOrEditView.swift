//
//  MealCreateOrEditView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI

struct MealCreateOrEditView: View {
    typealias PicturesAndNotes = AppModel.PicturesAndNotes
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel:AppViewModel;
    var mealId:String?;
    
    var body: some View {
        // We're either editing or creating a new meal in the model.
        let meal = viewModel.getOrAddMealFor(mealId)
        let mealId = meal.id;
        
        // TODO: Split my custom NavigationStack out into a custom view.
        NavigationStack {
            ZStack(alignment: .bottom) {
                Form {
                    LocationViews.LocationEditSection(
                        venue:Binding<String>(
                            get: { meal.venue.name },
                            set: { viewModel.setVenueNameFor(mealId, name:$0) }),
                        rating:Binding<Int>(
                            get: { meal.venue.rating },
                            set: { viewModel.setVenueRatingFor(mealId, rating:$0) })
                    )
                    DateViews.DatePickerSection()
                    PictureViews.PictureAndNotesEditSection(
                        title: "Menu[s]",
                        data: Binding<PicturesAndNotes>(
                            get: { meal.menu },
                            set: { viewModel.setMenuFor(mealId, menu:$0) }
                        )
                    )
                    CoursesViews.CoursesEditSection(meal:meal)
                    NotesViews.NotesEditSection(title:"Additional Notes", inputText: Binding<String>(
                        get: { meal.notes },
                        set: { viewModel.setNotesFor(mealId, notes:$0) }
                    ))
                }

                SaveButton(
                    actionFunc: {
                        viewModel.updateMeal(mealId, meal: meal)
                        print("Saved course id: \(mealId)\n      meal: \(meal)")
                    }
                )
            }
            .navigationBarBackButtonHidden()
            .navigationBarItems(
                leading: Text("Edit Meal")
                    .font(.system(size:36, weight: .bold)),
                trailing: HStack {
                    Button(
                        action: { self.presentationMode.wrappedValue.dismiss() },
                        label: {
                            Image(systemName: "x.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                        }
                    )
                })
        }
    }
}

#Preview {
    MealCreateOrEditView(mealId:"m1")
        .environmentObject(AppViewModel(numTestMeals:5))
}
