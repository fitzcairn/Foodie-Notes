//
//  CourseSubViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import SwiftUI

// All views and logic related to courses.
struct CourseSubViews {
    
    struct CoursesViewSection : View {
        @EnvironmentObject private var viewModel:AppViewModel;
        let courses:[Course];
        
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

    struct CourseNameAndPickedImageView : View {
        @EnvironmentObject private var viewModel:AppViewModel;
        let course:Course
        
        var body: some View {
            PictureSubViews.PictureNameRatingView(
                name:course.name,
                picture:viewModel.getCourseImageFor(course),
                rating:course.rating
            )
        }
    }
    
    // Individual course in a list
    struct CourseItemView: View {
        @EnvironmentObject private var viewModel:AppViewModel;
        var course:Course
        
        var body: some View {
            ZStack {
                HStack {
                    PhotoSubViews.PhotoShowView(picture:viewModel.getCourseImageFor(course))
                    VStack(alignment: .leading) {
                        HStack {
                            Text(course.name)
                                .bold()
                            Spacer()
                            RatingSubViews.RatingView(rating:course.rating)
                        }
                        Text(course.food.notes)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(8)
                    Spacer()
                }
                NavigationLink(destination: CourseView(course:course)) {
                    EmptyView()
                }
            }
        }
    }
}
