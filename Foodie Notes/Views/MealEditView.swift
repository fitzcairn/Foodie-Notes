//
//  MealEditView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI

struct MealEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel:AppViewModel;
    
    @Binding var meal:Meal;

    @State private var showingAlert = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollForm {
                    PictureSubViews.MealPictureNameRatingEditView(
                        name: $meal.venue.name,
                        picture: $meal.pickedImage,
                        rating: $meal.rating,
                        michelin: $meal.venue.michelin
                    )
                    DateSubViews.DatePickerSection(
                        selectedDate: $meal.date
                    )
                    CuisineSubViews.CuisineEditSection(
                        cuisines:$meal.cuisines
                    )
                    NotesSubViews.NotesEditSection(
                        title: SectionTitle.notes,
                        inputText: $meal.notes
                    )
                    PictureSubViews.PictureAndNotesEditSection(
                        title: SectionTitle.menus,
                        data: $meal.menu
                    )
                    CourseSubViews.CoursesEditSection(courses:$meal.courses)
                }
                PrimaryButtonSubViews.EditViewPrimaryButtons(
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
            leading: StyledTitleText(ViewTitle.editMeal)
        )
    }
}

