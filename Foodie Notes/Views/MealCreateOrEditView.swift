//
//  MealCreateOrEditView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI

struct MealCreateOrEditView: View {
    typealias Meal = AppModel.Meal
    typealias Course = AppModel.Course
    typealias PicturesAndNotes = AppModel.PicturesAndNotes

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel:AppViewModel;
    var mealId:String?;
    
    var body: some View {
        // We're either editing or creating a new meal in the model.
        var meal = viewModel.getOrAddMealFor(mealId)
        var dirty = false;
        
        // TODO: Split my custom NavigationStack out into a custom view.
        NavigationStack {
            ZStack(alignment: .bottom) {
                Form {
                    LocationSubViews.LocationEditSection(
                        venue:Binding<String>(
                            get: { meal.venue.name },
                            set: { meal.venue.name = $0; dirty.toggle() }),
                        rating:Binding<Int>(
                            get: { meal.venue.rating },
                            set: { meal.venue.rating = $0; dirty.toggle() })
                    )
                    DateViews.DatePickerSection(
                        selectedDate: Binding<Date>(
                            get: { meal.date },
                            set: { meal.date = $0; dirty.toggle() })
                    )
                    PictureSubViews.PictureAndNotesEditSection(
                        title: "Menu[s]",
                        data: Binding<PicturesAndNotes>(
                            get: { meal.menu },
                            set: { meal.menu = viewModel.removeDeletedImagesFor($0); dirty.toggle() })
                    )
                    CourseSubViews.CoursesEditSection(
                        courses: Binding<[Course]>(
                            get: { meal.courses },
                            set: { meal.courses = $0; dirty.toggle() }),
                        mealId:meal.id
                    )
                    NotesSubViews.NotesEditSection(title:"Additional Notes", inputText: Binding<String>(
                        get: { meal.notes },
                        set: { meal.notes = $0; dirty.toggle() }
                    ))
                }

                SaveButton(
                    actionFunc: {
                        if (dirty) {
                            viewModel.updateMeal(meal.id, meal: meal)
                            print("Saved course id: \(String(describing: mealId))\n      meal: \(meal)")
                        }
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
