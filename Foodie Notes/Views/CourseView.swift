//
//  CourseView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/30/24.
//

import SwiftUI

struct CourseView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel:AppViewModel;
    let courseId:String?;
    
    var body: some View {
        if let course = viewModel.getCourseFor(courseId) {
            
            // TODO: Split my custom NavigationStack out into a custom view.
            NavigationStack {
                Form {
                    CoursesViews.CourseNameAndPickedImageView(mealId:course.mealId, courseId: courseId)
                    DateViews.DateSection(course.date)
                    PictureViews.PictureAndNotesViewSection(title: "Food", data: course.food)
                    if viewModel.checkShow(course.wine) {
                        PictureViews.PictureAndNotesViewSection(title: "Wine", data: course.wine)
                    }
                }
                
                .navigationBarBackButtonHidden()
                .navigationBarItems(
                    leading: Text("View Course")
                        .font(.system(size:36, weight: .bold)),
                    trailing: HStack {
                        NavigationLink(destination: CourseCreateOrEditView(mealId:course.mealId, courseId: courseId)) {
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
                    })
            }
        }
    }
}

#Preview {
    CourseView(courseId:"c1")
        .environmentObject(AppViewModel(numTestMeals:5))
}
