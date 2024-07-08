//
//  CourseCreateOrEditView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI


struct CourseCreateOrEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel:AppViewModel;
    
    @State private var showingAlert = false
    
    let title:String
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollForm {
                    PictureSubViews.PictureNameRatingEditView(
                        name:$viewModel.courseBeingEdited.name,
                        picture:$viewModel.courseBeingEdited.pickedImage,
                        rating:$viewModel.courseBeingEdited.rating
                    )
                    DateViews.DatePickerSection(selectedDate:$viewModel.courseBeingEdited.date)
                    PictureSubViews.PictureAndNotesEditSection(
                        title: "Food",
                        data: $viewModel.courseBeingEdited.food
                    )
                    PictureSubViews.PictureAndNotesEditSection(
                        title: "Beverage Pairing",
                        data: $viewModel.courseBeingEdited.beveragePairing
                    )
                }
                EditScreenPrimaryButtons(
                    cancelFunc: {
                        
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    saveFunc: {
                        showingAlert = viewModel.courseBeingEdited.name.isEmpty;
                        if !showingAlert {
                            // If we're editing a meal, we want to make sure to update the meal being edited.
                            if (viewModel.isEditingMeal) {
                                viewModel.updateMealBeingEditedlWith(viewModel.courseBeingEdited)
                            } else {
                                // Persist the changes to the existing meal.
                                viewModel.saveEditedCourse()
                            }
                            presentationMode.wrappedValue.dismiss()
                        }
                    },
                    fieldName: "name",
                    showingAlert: $showingAlert
                )
            }
            .navigationBarBackButtonHidden()
            .navigationBarItems(
                leading: Text(title)
                    .font(.system(size:36, weight: .bold))
            )
        }
    }
}

