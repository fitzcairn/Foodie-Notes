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
        let courses:[Course]
        @State var needRefresh: Bool = false

        
        var body: some View {
            Section(header: Text("Courses")) {
                List {
                    ForEach(courses) { course in
                        CourseItemView<CourseView>(isEdit:false, course:course) {
                            CourseView(
                                needRefresh:$needRefresh,
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
        @State var needRefresh: Bool = false


        var body: some View {
            let courses = viewModel.getCoursesFor(mealId)
            if courses == nil {
                EmptyView()
            }
            else {
                var courses = courses!
                Section(header: header) {
                    List {
                        ForEach(courses.indices, id:\.self) { index in
                            CourseItemView<CourseCreateOrEditView>(isEdit: true, course:courses[index]) {
                                CourseCreateOrEditView(
                                    needRefresh:$needRefresh,
                                    mealId:courses[index].mealId,
                                    courseId:courses[index].id
                                )
                            }
                        }
                        .onMove { from, to in
                            courses.move(fromOffsets: from, toOffset: to)
                            viewModel.setCoursesFor(mealId, courses: courses)
                        }
                        .onDelete() { at in
                            remove(at:at, courses: courses)
                        }
                    }
                }
            }
        }
        
        var header: some View {
            HStack {
                Text("Courses")
                Spacer()
                NavigationLink(
                    destination:CourseCreateOrEditView(
                        needRefresh:$needRefresh,
                        mealId:mealId,
                        courseId:nil
                    )
                ) {
                    SecondaryAddButtonImage()
                }
                .simultaneousGesture(TapGesture().onEnded {
                    _ = viewModel.addNewCourseTo(mealId)
                })
            }
        }
        
        func remove(at offsets: IndexSet, courses:[Course]) {
            var newCourses:[Course] = []
            for (index, course) in courses.enumerated() {
                if !offsets.contains(index) {
                    newCourses.append(course);
                }
            }
            viewModel.setCoursesFor(mealId, courses:newCourses)
        }
    }
        
    struct CourseNameAndPickedImageView : View {
        @EnvironmentObject private var viewModel:AppViewModel;
        let mealId:String;
        let course:Course;
        
        var body: some View {
            PictureSubViews.PictureAndNameView(
                name:viewModel.getCourseFor(course.id).name,
                picture:viewModel.getCourseFor(course.id).pickedImage
            )
        }
    }
    
    // Individual course in a list
    struct CourseItemView<Destination>: View where Destination : View {
        @EnvironmentObject private var viewModel:AppViewModel;
        let isEdit:Bool;
        let course:Course
        let destination: Destination

        init(isEdit:Bool, course: Course, @ViewBuilder destination: @escaping () -> Destination) {
            self.isEdit = isEdit
            self.course = course
            self.destination = destination()
        }
        
        var body: some View {
            ZStack {
                HStack {
                    PhotoSubViews.PhotoShowView(picture:viewModel.getCourseFor(course.id).pickedImage)
                    VStack(alignment: .leading) {
                        Text(course.name)
                            .bold()
                        Text(course.food.notes)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(8)
                    Spacer()
                    if (isEdit) {
                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.gray)
                            .opacity(0.6)
                    }
                }
                NavigationLink(destination: destination) {
                    EmptyView()
                }
                .opacity(isEdit ? 0 : 1)
            }
        }
    }
    
}
