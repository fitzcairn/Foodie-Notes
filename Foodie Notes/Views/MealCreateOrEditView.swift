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
    @Binding var needRefresh: Bool
    
    let mealId:String?
    
    var body: some View {
        let isNew = mealId == nil;
        let title = !isNew ? "Edit Meal" : "Create Meal"
        
        if isNew && viewModel.getLastNewMealCreated() == nil {
            // Can happen on a back from a new meal.  I can't stop one last refresh before the view
            // dismisses.  #SwiftUI.
            EmptyView()
        } else {
            let meal = isNew ? viewModel.getLastNewMealCreated()! : viewModel.getMealFor(mealId)!
            let mealId = meal.id;
            
            // TODO: Split my custom NavigationStack out into a custom view.
            NavigationStack {
                ZStack(alignment: .bottom) {
                    ScrollForm {
                        PictureSubViews.PictureNameRatingEditView(
                            name:Binding<String>(
                                get: { viewModel.getMealFor(mealId)?.venue.name ?? "" },
                                set: { viewModel.setVenueNameFor(mealId, name: $0) }),
                            picture:Binding<Picture?>(
                                get: { viewModel.getMealImageFor(mealId) },
                                set: { viewModel.setMealPickedPictureFor(mealId, img: $0!) }),
                            rating:Binding<Int>(
                                get: { viewModel.getMealFor(mealId)?.rating ?? 0 },
                                set: { viewModel.setMealRatingFor(mealId, rating:$0) })
                        )
                        DateViews.DatePickerSection(
                            selectedDate: Binding<Date>(
                                get: { meal.date },
                                set: { viewModel.setDateFor(mealId, date:$0) })
                        )
                        NotesSubViews.NotesEditSection(title:"Overall Notes", inputText: Binding<String>(
                            get: { meal.notes },
                            set: { viewModel.setNotesFor(mealId, notes: $0) }
                        ))
                        PictureSubViews.PictureAndNotesEditSection(
                            title: "Menu[s]",
                            data: Binding<PicturesAndNotes>(
                                get: { meal.menu },
                                set: { viewModel.setMenuFor(mealId, menu:$0) })
                        )
                        CourseSubViews.CoursesEditSection(mealId: meal.id)
                    }
                    EditScreenPrimaryButtons(
                        cancelFunc: {
                            // Make sure we don't save an empty meal.
                            if isNew {
                                viewModel.removeMeal(mealId)
                            }
                            needRefresh.toggle()
                            self.presentationMode.wrappedValue.dismiss()
                        },
                        saveFunc: {
                            viewModel.objectWillChange.send()
                            showingAlert = !viewModel.mealHasVenue(mealId);
                            if !showingAlert {
                                needRefresh.toggle()
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
}

