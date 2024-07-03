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
    
    typealias Meal = AppModel.Meal
    typealias Course = AppModel.Course
    typealias PicturesAndNotes = AppModel.PicturesAndNotes

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
                    Form {
                        LocationSubViews.LocationEditSection(
                            venue:Binding<String>(
                                get: { meal.venue.name },
                                set: { viewModel.setVenueFor(mealId, name: $0) }),
                            rating:Binding<Int>(
                                get: { meal.venue.rating },
                                set: { viewModel.setRatingFor(mealId, rating:$0) })
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
                    SaveButton(
                        actionFunc: {
                            viewModel.objectWillChange.send()
                            showingAlert = !viewModel.mealHasVenue(mealId);
                            if !showingAlert {
                                needRefresh.toggle()
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    )
                    .alert("Oops!", isPresented: $showingAlert) {
                        Text("Please add a venue.")
                        Button("OK", role: .cancel) { }
                    }
                }
                .navigationBarBackButtonHidden()
                .navigationBarItems(
                    leading: Text(title)
                        .font(.system(size:36, weight: .bold)),
                    trailing: HStack {
                        Button(
                            action: {
                                // Make sure we don't save an empty meal.
                                if isNew {
                                    viewModel.removeMeal(mealId)
                                }
                                self.presentationMode.wrappedValue.dismiss()
                            },
                            label: {
                                Image(systemName: "x.circle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.blue)
                            }
                        )
                    }
                )
            }
        }
    }
}

