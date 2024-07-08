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
                        CourseItemView<CourseView>(
                            showEditIcon:false,
                            course:course) {
                            CourseView(
                                courseId:course.id,
                                mealId: course.mealId)
                        }
                    }
                }
            }
        }
    }
    
    struct CoursesEditSection : View {
        @EnvironmentObject private var viewModel:AppViewModel;
        let mealId:String;
        @Binding var courses:[Course]
        @State var needRefresh: Bool = false

        var body: some View {
            Section(header: header) {
                List {
                    ForEach(Array(zip(courses.indices, courses)), id: \.0) { index, item in
                        CourseItemView<CourseCreateOrEditView>(
                            showEditIcon: true,
                            course:courses[index]) {
                                CourseCreateOrEditView(title: "Edit Course")
                            }
                    }
                    .onMove { from, to in
                        courses.move(fromOffsets: from, toOffset: to)
                    }
                    .onDelete(perform: { indexSet in
                        courses.remove(atOffsets: indexSet)
                    })
                }
            }
        }
        
        var header: some View {
            HStack {
                Text("Courses")
                Spacer()
                NavigationLink(destination:CourseCreateOrEditView(title: "Create New Course"))
                {
                    SecondaryAddButtonImage()
                }
                .simultaneousGesture(TapGesture().onEnded {
                    viewModel.setNewCourse(courseId: nil, mealId: mealId)
                })
            }
        }
    }
        
    struct CourseNameAndPickedImageView : View {
        @EnvironmentObject private var viewModel:AppViewModel;
        let mealId:String;
        let courseId:String;
        
        var body: some View {
            PictureSubViews.PictureNameRatingView(
                name:viewModel.getCourseFor(courseId)?.name,
                picture:viewModel.getCourseImageFor(courseId),
                rating:viewModel.getCourseFor(courseId)?.rating
            )
        }
    }
    
    // Individual course in a list
    struct CourseItemView<Destination>: View where Destination : View {
        @EnvironmentObject private var viewModel:AppViewModel;
        var course:Course
        let showEditIcon:Bool;
        let destination: Destination
        
        @State var isTapped = false;

        init(showEditIcon:Bool, course:Course, @ViewBuilder destination: @escaping () -> Destination) {
            self.showEditIcon = showEditIcon
            self.course = course
            self.destination = destination()
        }
        
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
                    if (showEditIcon) {
                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.gray)
                            .opacity(0.6)
                    }
                }
                // TODO: once I solve passing a binding to course correctly, remove this hack.
                NavigationLink(destination: destination,
                               isActive: Binding<Bool>(
                                get: { isTapped },
                                set: {
                                    isTapped = $0;
                                    if (showEditIcon) {
                                        viewModel.setNewCourse(course)
                                    }
                                })
                ) {
                    EmptyView()
                }
                .opacity(showEditIcon ? 0 : 1)
            }
        }
    }
}
