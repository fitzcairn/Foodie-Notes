//
//  CourseSubViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import SwiftUI



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
                        RatingView(rating:course.rating)
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

// All views and logic related to courses.
struct CourseSubViews {
    
    struct CoursesViewSection : View {
        @EnvironmentObject private var viewModel:AppViewModel;
        let courses:[Course];
        
        var body: some View {
            Section(header: Text(SectionTitle.courses)) {
                List {
                    ForEach(courses) { course in
                     CourseItemView(course:course)
                     }
                }
                .id(UUID())
            }
        }
    }
    
    struct CoursesEditSection : View {
        @EnvironmentObject private var viewModel:AppViewModel;
        @Binding var courses:[Course];
        
        var body: some View {
            Section(header: Text(SectionTitle.courses)) {
                List {
                    ForEach(Array(zip(courses.indices, courses)), id: \.0) { index, item in
                        CourseItemView(course:courses[index])
                    }
                    .onMove { from, to in
                        courses.move(fromOffsets: from, toOffset: to)
                    }
                    .onDelete(perform: { indexSet in
                        courses.remove(atOffsets: indexSet)
                    })
                }
                .id(UUID())
            }
        }
    }

    struct CourseNameAndPickedImageView : View {
        @EnvironmentObject private var viewModel:AppViewModel;
        let course:Course
        
        var body: some View {
            PictureSubViews.CoursePictureNameRatingView(
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
                            RatingView(rating:course.rating)
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
