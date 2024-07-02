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

    typealias Course = AppModel.Course
    
    let course:Course;
    
    var body: some View {
        // TODO: Split my custom NavigationStack out into a custom view.
        NavigationStack {
            Form {
                CourseSubViews.CourseNameAndPickedImageView(mealId:course.mealId, course: course)
                DateViews.DateSection(course.date)
                PictureSubViews.PictureAndNotesViewSection(title: "Food", data: course.food)
                if viewModel.checkShow(course.wine) {
                    PictureSubViews.PictureAndNotesViewSection(title: "Wine", data: course.wine)
                }
            }
            
            .navigationBarBackButtonHidden()
            .navigationBarItems(
                leading: Text("View Course")
                    .font(.system(size:36, weight: .bold)),
                trailing: HStack {
                    NavigationLink(destination: CourseCreateOrEditView(mealId:course.mealId, course: course)) {
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
    CourseView(course:AppViewModel(numTestMeals:5).getCourseFor("c1")!)
        .environmentObject(AppViewModel(numTestMeals:5))
}
