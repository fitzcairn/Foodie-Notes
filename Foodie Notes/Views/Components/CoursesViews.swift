//
//  CoursesViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import SwiftUI

// All views and logic related to courses.
struct CoursesViews {
    typealias Meal = AppModel.Meal;
    typealias Course = AppModel.Course;
    typealias Picture = AppModel.Picture;
    
    struct CoursesViewSection : View {
        @EnvironmentObject private var viewModel:AppViewModel;
        let meal:Meal

        var body: some View {
            Section(header: Text("Courses")) {
                List {
                    ForEach(meal.courseIds) { course in
                        CourseItemView(course:course)
                    }
                }
            }
        }
    }
    
    struct CoursesEditSection : View {
        @EnvironmentObject private var viewModel:AppViewModel;
        let meal:Meal;

        var body: some View {
            Section(header: header) {
                List {
                    ForEach(meal.courseIds) { course in
                        CourseItemView(course:course)
                    }
                    .onDelete(perform: remove)
                }
            }
        }
        
        var header: some View {
            HStack {
                Text("Courses")
                Spacer()
                NavigationLink(destination: CourseCreateOrEditView(mealId: meal.id, courseId:nil)) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.black)
                        .padding(.trailing, -20)
                }
            }
        }
        
        func remove(at offsets: IndexSet) {
            // TODO: implement
            // TODO: do we need multiple index removal at once?
            //viewModel.removeCourseFromMeal(mealId: mealId, at: offsets[0])
        }
    }
        
    struct CourseNameAndPickedImageView : View {
        @EnvironmentObject private var viewModel:AppViewModel;
        let mealId:String;
        let courseId:String?;

        init(mealId: String, courseId: String?) {
            self.mealId = mealId
            self.courseId = courseId
        }
        
        var body: some View {
            let course = viewModel.getOrAddCourseFor(mealId: mealId, courseId: courseId)
            PictureViews.PictureAndNameView(name:course.name,
                                            image:viewModel.getPreferredImageSrc(for: course))
        }
    }
    
    // Individual course in a list
    struct CourseItemView : View {
        @EnvironmentObject private var viewModel:AppViewModel;
        let course:Course

        var body: some View {
            HStack {
                Image(systemName: viewModel.getPreferredImageSrc(for: course))
                    .resizable()
                    .frame(width: 64.0, height: 64.0)
                NavigationLink(destination: CourseCreateOrEditView(mealId:course.mealId, courseId:course.id)) {
                    VStack(alignment: .leading) {
                        Text(course.name)
                            .bold()
                        Text(course.food.notes)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(8)
                }
            }
        }
    }
    
}
