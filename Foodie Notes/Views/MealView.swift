//
//  MealView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI

struct MealView: View {
    let mealId:String;
    @ObservedObject var viewModel:AppViewModel;
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    
    var body: some View {
        if let meal = viewModel.getMealFor(mealId) {
            // TODO: Split my custom NavigationStack out into a custom view.
            NavigationStack {
                Form {
                    LocationViews.LocationViewSection(venue: meal.getVenue().name, rating: meal.getVenue().rating)
                    DateViews.DateSection(Date())
                    
                    // Menu
                    if let menu = meal.menu {
                        PictureViews.PictureAndNotesViewSection(title: "Menu[s]", data: menu)
                    }
                    
                    // Courses!
                    CoursesViews.CoursesViewSection()
                    
                    // Notes
                    if let note = meal.notes {
                        NotesViews.NotesSection(
                            title:"Additional Notes",
                            note: note
                        )
                    }
                }
                .navigationBarBackButtonHidden()
                .navigationBarItems(
                    leading: Text("View Meal")
                        .font(.system(size:36, weight: .bold)),
                    trailing: HStack {
                        NavigationLink(destination: MealCreateOrEditView()) {
                            Image(systemName: "pencil")
                                .resizable()
                                .padding(6)
                                .frame(width: 24, height: 24)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }
                        Button(
                            action: {
                                dismiss()
                            },
                            label: {
                                Image(systemName: "x.circle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.blue)
                            }
                        )
                    })
            }
        } else {
            Button(
                action: { self.presentationMode.wrappedValue.dismiss() },
                label: {
                    Text("Oops! Something went wrong.\n\nClick to go back.")
                }
            )
        }
    }
}

#Preview {
    MealView(mealId:"m1", viewModel: AppViewModel(numTestMeals:5))
}
