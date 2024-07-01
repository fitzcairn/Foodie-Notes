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
    let mealId:String;
    let courseId:String?;

    var body: some View {
        // We're either editing or creating a new meal in the model.
        let course = viewModel.getOrAddCourseFor(mealId: mealId, courseId:courseId)
        let courseId = course.id;
        
        NavigationStack {
            ZStack(alignment: .bottom) {
                Form {
                    PictureViews.PictureAndNameEditView(
                        name:Binding<String>(
                            get: { course.name },
                            set: { viewModel.setVenueNameFor(mealId, name:$0) }),
                        rating:Binding<Int>(
                            get: { meal.venue.rating },
                            set: { viewModel.setVenueRatingFor(mealId, rating:$0) })
                    )
                        
                        
                        
                        name: .constant("whee"), image: .constant("plus"))
                    DateViews.DatePickerSection(selectedDate: Date())
                    PictureViews.PictureAndNotesEditSection(title: "Food", data: course.food)
                    PictureViews.PictureAndNotesEditSection(title: "Wine", data: course.wine)
                }

                SaveButton(
                    actionFunc: {
                        
                        // TODO: Write the course we built here back to the viewmodel.
                        
                        print("Saving course " + courseId)
                    }
                )
            }
            .navigationBarBackButtonHidden()
            .navigationBarItems(
                leading: Text("Edit Course")
                    .font(.system(size:36, weight: .bold)),
                trailing: Button(
                    action: { self.presentationMode.wrappedValue.dismiss() },
                    label: {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.blue)
                    }
                )
            )
        }
    }
}

#Preview {
    CourseCreateOrEditView(courseId:"c1")
        .environmentObject(AppViewModel(numTestMeals:5))
}

