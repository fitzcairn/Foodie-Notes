//
//  MealCreateView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/16/24.
//

import SwiftUI

struct MealCreateView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel:AppViewModel;
    
    @State private var showingAlert = false
    @ObservedObject private var meal:WrappedStruct<Meal> = WrappedStruct(withItem:Meal())
        
    var body: some View {
        // TODO: Split my custom NavigationStack out into a custom view.
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollForm {
                    PictureSubViews.PictureNameRatingEditView(
                        name: $meal.item.venue.name,
                        picture: $meal.item.pickedImage,
                        rating: $meal.item.rating
                    )
                    DateViews.DatePickerSection(
                        selectedDate: $meal.item.date
                    )
                    NotesSubViews.NotesEditSection(
                        title:"Overall Notes",
                        inputText: $meal.item.notes
                    )
                    PictureSubViews.PictureAndNotesEditSection(
                        title: "Menu[s]",
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
        }
        .navigationBarBackButtonHidden()
        .navigationBarItems(
            leading: Text("Create a New Meal")
                .font(.system(size:36, weight: .bold))
        )
    }
}
