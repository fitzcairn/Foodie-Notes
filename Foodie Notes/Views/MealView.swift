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
        if viewModel.getMealFor(mealId) == nil {
            ErrorDialog(text:"Something went wrong looking up your meal!")
        } else {
            NavigationStack {
                ZStack(alignment: .bottom) {
                    ScrollForm {
                        LocationSubViews.LocationViewSection(venue: viewModel.getMealFor(mealId)!.venue.name, rating: viewModel.getMealFor(mealId)!.venue.rating)
                        DateViews.DateSection(viewModel.getMealFor(mealId)!.date)
                        if !viewModel.getMealFor(mealId)!.notes.isEmpty {
                            NotesSubViews.NotesSection(
                                title:"Overall Notes",
                                note: viewModel.getMealFor(mealId)!.notes
                            )
                        }
                        if viewModel.checkShow(viewModel.getMealFor(mealId)!.menu) {
                            PictureSubViews.PictureAndNotesViewSection(title: "Menu[s]", data:viewModel.getMealFor(mealId)!.menu)
                        }
                        CourseSubViews.CoursesViewSection(courses:viewModel.getMealFor(mealId)!.courses)
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
}
