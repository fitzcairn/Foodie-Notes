//
//  MealCreateOrEditView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI

struct MealCreateOrEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel:AppViewModel;
    
    typealias Meal = AppModel.Meal
    typealias Course = AppModel.Course
    typealias PicturesAndNotes = AppModel.PicturesAndNotes

    let meal:Meal?

    var body: some View {
        // New meal to send to child view via bindings.
        var newMeal = self.meal ?? Meal()
        var dirty = false;

        // TODO: Split my custom NavigationStack out into a custom view.
        NavigationStack {
            ZStack(alignment: .bottom) {
                Form {
                    LocationSubViews.LocationEditSection(
                        venue:Binding<String>(
                            get: { newMeal.venue.name },
                            set: { newMeal.venue.name = $0; dirty = true }),
                        rating:Binding<Int>(
                            get: { newMeal.venue.rating },
                            set: { newMeal.venue.rating = $0; dirty = true })
                    )
                    DateViews.DatePickerSection(
                        selectedDate: Binding<Date>(
                            get: { newMeal.date },
                            set: { newMeal.date = $0; dirty = true })
                    )
                    PictureSubViews.PictureAndNotesEditSection(
                        title: "Menu[s]",
                        data: Binding<PicturesAndNotes>(
                            get: { newMeal.menu },
                            set: { newMeal.menu = viewModel.removeDeletedImagesFor($0); dirty = true })
                    )
                    CourseSubViews.CoursesEditSection(
                        mealId: newMeal.id,
                        courses: Binding<[Course]>(
                            get: { newMeal.courses },
                            set: { newMeal.courses = $0; dirty = true })
                    )
                    NotesSubViews.NotesEditSection(title:"Additional Notes", inputText: Binding<String>(
                        get: { newMeal.notes },
                        set: { newMeal.notes = $0; dirty = true }
                    ))
                }

                SaveButton(
                    actionFunc: {
                        if (dirty) {
                            viewModel.objectWillChange.send()
                            viewModel.updateMeal(newMeal.id, meal: newMeal)
                            print("Saved:\n-->meal id: \(String(describing: newMeal.id))\n-->meal: \(newMeal)")
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
    MealCreateOrEditView(meal:nil)
        .environmentObject(AppViewModel(numTestMeals:5))
}
