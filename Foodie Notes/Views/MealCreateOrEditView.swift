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
    
    @State private var showingAlert = false
    
    let title:String
    
    var body: some View {
        // TODO: Split my custom NavigationStack out into a custom view.
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollForm {
                    PictureSubViews.PictureNameRatingEditView(
                        name: $viewModel.mealBeingEdited.venue.name,
                        picture: $viewModel.mealBeingEdited.pickedImage,
                        rating: $viewModel.mealBeingEdited.rating
                    )
                    DateViews.DatePickerSection(
                        selectedDate: $viewModel.mealBeingEdited.date
                    )
                    NotesSubViews.NotesEditSection(
                        title:"Overall Notes",
                        inputText: $viewModel.mealBeingEdited.notes
                    )
                    PictureSubViews.PictureAndNotesEditSection(
                        title: "Menu[s]",
                        data: $viewModel.mealBeingEdited.menu
                    )
                    CourseSubViews.CoursesEditSection(
                        mealId: viewModel.mealBeingEdited.id,
                        courses: $viewModel.mealBeingEdited.courses)
                }
                EditScreenPrimaryButtons(
                    cancelFunc: {
                        viewModel.beginCreatingNewMeal();
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    saveFunc: {
                        showingAlert = viewModel.mealBeingEdited.venue.name.isEmpty
                        if !showingAlert {
                            viewModel.saveEditedMealFor(viewModel.mealBeingEdited)
                            presentationMode.wrappedValue.dismiss()
                        }
                    },
                    fieldName: "venue",
                    showingAlert: $showingAlert
                )
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarItems(
            leading: Text(title)
                .font(.system(size:36, weight: .bold))
        )
    }
}

