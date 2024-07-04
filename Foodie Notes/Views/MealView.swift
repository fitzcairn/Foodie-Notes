//
//  MealView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI

struct MealView: View {
    typealias PicturesAndNotes = AppModel.PicturesAndNotes
    typealias Meal = AppModel.Meal

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel:AppViewModel;

    @State var needRefresh: Bool = false
    
    let mealId:String;
    
    var body: some View {
        let meal = viewModel.getMealFor(mealId) ?? Meal()
        
        // TODO: Split my custom NavigationStack out into a custom view.
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollForm {
                    LocationSubViews.LocationViewSection(venue: meal.venue.name, rating: meal.venue.rating)
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
                    backFunc: {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    editDest: MealCreateOrEditView(
                        needRefresh:$needRefresh,
                        mealId:mealId)
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
