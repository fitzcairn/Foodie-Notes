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
    
    @State private var showingAlert = false
    @ObservedObject private var meal:WrappedStruct<Meal>;
    
    init(meal:Meal) {
        // Note: Code smell to set state here, but best way I've found to fight weirdness with bindings on properties.
        _meal = ObservedObject(wrappedValue: WrappedStruct(withItem:meal))
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollForm {
                    PictureSubViews.MealPictureNameRatingEditView(
                        picture: $meal.item.pickedImage,
                        rating: $meal.item.rating,
                        venue: $meal.item.venue
                    )
                    DateSubViews.DatePickerSection(
                        selectedDate: $meal.item.date
                    )
                    CuisineSubViews.CuisineEditSection(
                        cuisines:$meal.item.cuisines
                    )
                    NotesSubViews.NotesEditSection(
                        title: SectionTitle.notes,
                        inputText: $meal.item.notes
                    )
                    PictureSubViews.PictureAndNotesEditSection(
                        title: SectionTitle.menus,
                        data: $meal.item.menu
                    )
                    CourseSubViews.CoursesEditSection(courses:$meal.item.courses)
                }
                PrimaryButtonSubViews.EditViewPrimaryButtons(
                    cancelFunc: {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    saveFunc: {
                        showingAlert = meal.item.venue.name.isEmpty
                        if !showingAlert {
                            viewModel.saveEditedMealFor(meal.item)
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

