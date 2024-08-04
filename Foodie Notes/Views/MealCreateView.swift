//
//  MealCreateView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/16/24.
//

import SwiftUI

struct MealCreateView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var viewModel:AppViewModel;

    
    @State private var showingAlert = false
    @ObservedObject private var meal:WrappedStruct<Meal>;
    
    init(meal:Meal) {
        self.meal = WrappedStruct(withItem:meal)
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
            .onAppear() {
                // New meal for each create call.
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarItems(
            leading: StyledTitleText(ViewTitle.createMeal)
        )
    }
}
