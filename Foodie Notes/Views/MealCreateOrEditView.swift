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
    @Binding var meal:Meal;
        
    var body: some View {
        // TODO: Split my custom NavigationStack out into a custom view.
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollForm {
                    PictureSubViews.PictureNameRatingEditView(
                        name: $meal.venue.name,
                        picture: $meal.pickedImage,
                        rating: $meal.rating
                    )
                    DateViews.DatePickerSection(
                        selectedDate: $meal.date
                    )
                    NotesSubViews.NotesEditSection(
                        title:"Overall Notes",
                        inputText: $meal.notes
                    )
                    PictureSubViews.PictureAndNotesEditSection(
                        title: "Menu[s]",
                        data: $meal.menu
                    )
                    CourseSubViews.CoursesEditSection(
                        mealId: meal.id,
                        courses: $meal.courses)
                }
                EditScreenPrimaryButtons(
                    cancelFunc: {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    saveFunc: {
                        showingAlert = meal.venue.name.isEmpty
                        if !showingAlert {
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

