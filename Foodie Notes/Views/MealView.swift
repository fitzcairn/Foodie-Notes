//
//  MealView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI

struct MealView: View {
    typealias PicturesAndNotes = AppModel.PicturesAndNotes
    typealias Meal = AppModel.Meal

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel:AppViewModel;
    let meal:Meal
    
    var body: some View {
        // TODO: Split my custom NavigationStack out into a custom view.
        NavigationStack {
            Form {
                LocationSubViews.LocationViewSection(venue: meal.venue.name, rating: meal.venue.rating)
                DateViews.DateSection(Date())
                
                // Menu, if not empty.
                if viewModel.checkShow(meal.menu) {
                    PictureSubViews.PictureAndNotesViewSection(title: "Menu[s]", data:meal.menu)
                }
                
                // Courses!
                CourseSubViews.CoursesViewSection(courses:meal.courses)
                
                // Notes
                if !meal.notes.isEmpty {
                    NotesSubViews.NotesSection(
                        title:"Additional Notes",
                        note: meal.notes
                    )
                }
            }
            .navigationBarBackButtonHidden()
            .navigationBarItems(
                leading: Text("View Meal")
                    .font(.system(size:36, weight: .bold)),
                trailing: HStack {
                    NavigationLink(destination: MealCreateOrEditView(meal:meal)) {
                        Image(systemName: "pencil")
                            .resizable()
                            .padding(6)
                            .frame(width: 24, height: 24)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .foregroundColor(.white)
                    }
                    Button(
                        action: { self.presentationMode.wrappedValue.dismiss() },
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

#Preview {
    MealView(meal:AppViewModel(numTestMeals:5).getMealFor("m1")!)
        .environmentObject(AppViewModel(numTestMeals:5))
}
