//
//  CourseSubViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import SwiftUI

// All views and logic related to courses.
struct CourseSubViews {
    typealias Meal = AppModel.Meal;
    typealias Course = AppModel.Course;
    typealias Picture = AppModel.Picture;
    
    struct CoursesViewSection : View {
        @EnvironmentObject private var viewModel:AppViewModel;
        let courses:[Course]

        var body: some View {
            Section(header: Text("Courses")) {
                List {
                    ForEach(courses) { course in
                        CourseItemView(course:course)
                    }
                }
            }
        }
    }
    
    struct CoursesEditSection : View {
        @EnvironmentObject private var viewModel:AppViewModel;
        let mealId:String;
        @Binding var courses:[Course];

        var body: some View {
            Section(header: header) {
                List {
                    ForEach(courses) { course in
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
                NavigationLink(destination: CourseCreateOrEditView(mealId: mealId, course:nil)) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.black)
                        .padding(.trailing, -20)
                }
            }
        }
        
        func remove(at offsets: IndexSet) {
            var new:[Course] = []
            for (index, course) in courses.enumerated() {
                if !offsets.contains(index) {
                    new.append(course);
                }
            }
            courses = new;
        }
    }
        
    struct CourseNameAndPickedImageView : View {
        @EnvironmentObject private var viewModel:AppViewModel;
        let mealId:String;
        let course:Course;
        
        var body: some View {
            PictureSubViews.PictureAndNameView(
                name:course.name,
                image:viewModel.getPreferredImageSrc(for: course)
            )
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
                NavigationLink(destination: CourseView(course:course)) {
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
