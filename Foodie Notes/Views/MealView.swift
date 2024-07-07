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

    @State var needMealRefresh: Bool = false
    @Binding var needListRefresh: Bool;
    
    let mealId:String;
    
    var body: some View {
        if viewModel.getMealFor(mealId) == nil {
            ErrorDialog(text:"Something went wrong looking up your meal!")
        } else {
            NavigationStack {
                ZStack(alignment: .bottom) {
                    ScrollForm {
                        PictureSubViews.PictureNameRatingView(
                            name: viewModel.getMealFor(mealId)?.venue.name,
                            picture: viewModel.getMealImageFor(mealId),
                            rating: viewModel.getMealFor(mealId)?.rating)
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
                        CourseSubViews.CoursesViewSection(mealId: mealId)
                    }
                    ViewScreenPrimaryButtons(
                        backFunc: {
                            needListRefresh.toggle()
                            viewModel.objectWillChange.send()
                            self.presentationMode.wrappedValue.dismiss()
                        },
                        editDest: MealCreateOrEditView(
                            needRefresh:$needMealRefresh,
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
