//
//  MealView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI

struct MealView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel:AppViewModel;
    
    var meal:Meal;

    var body: some View {
        var meal = viewModel.getMealFor(meal.id)!
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollForm {
                    PictureSubViews.PictureNameRatingView(
                        name: meal.venue.name,
                        picture: viewModel.getMealImageFor(meal),
                        rating: meal.rating)
                    DateViews.DateSection(meal.date)
                    if !meal.notes.isEmpty {
                        NotesSubViews.NotesSection(
                            title:"Overall Notes",
                            note: meal.notes
                        )
                    }
                    if viewModel.checkShow(meal.menu) {
                        PictureSubViews.PictureAndNotesViewSection(title: "Menu[s]", data:meal.menu)
                    }
                    CourseSubViews.CoursesViewSection(courses:meal.courses)
                }
                ViewScreenPrimaryButtons(
                    backClosure: {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    editDest: MealCreateOrEditView(
                        title: "Edit Meal"),
                    editClosure: {
                        viewModel.beginEditingMeal(meal)
                    }
                )
            }
            .navigationBarBackButtonHidden()
            .navigationBarItems(
                leading: Text("View Meal")
                    .font(.system(size:36, weight: .bold))
            )
        }
    }
}
