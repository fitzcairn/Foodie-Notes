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
    
    typealias Course = AppModel.Course
    
    @State private var showingAlert = false
    @Binding var needRefresh: Bool

    let mealId:String;
    var courseId:String?

    var body: some View {
        let isNew = courseId == nil;
        let title = !isNew ? "Edit Course" : "Create Course"

        if isNew && viewModel.getLastCourseFor(mealId) == nil {
            // Can happen on a back from a new course.  I can't stop one last refresh before the view
            // dismisses.  #SwiftUI.
            EmptyView()
        } else {
            let course = !isNew ? viewModel.getCourseFor(courseId!) : viewModel.getLastCourseFor(mealId)!
            
            NavigationStack {
                ZStack(alignment: .bottom) {
                    Form {
                        PictureSubViews.PictureAndNameEditView(
                            name:Binding<String>(
                                get: { course.name },
                                set: { viewModel.setCourseNameFor(course, name: $0) }),
                            picture:Binding<AppModel.Picture>(
                                get: { course.pickedImage },
                                set: { viewModel.setCoursePickedImageFor(course, image:$0) })
                        )
                        DateViews.DatePickerSection(
                            selectedDate: Binding<Date>(
                                get: { course.date },
                                set: { viewModel.setCourseDateFor(course, date:$0) })
                        )
                        PictureSubViews.PictureAndNotesEditSection(
                            title: "Food",
                            data: Binding<AppModel.PicturesAndNotes>(
                                get: { course.food },
                                set: { viewModel.setCourseFoodFor(course, food:$0); }
                            )
                        )
                        PictureSubViews.PictureAndNotesEditSection(
                            title: "Wine",
                            data: Binding<AppModel.PicturesAndNotes>(
                                get: { viewModel.getCourseFor(course.id).wine },
                                set: { viewModel.setCourseWineFor(course, wine:$0) })
                        )
                    }
                    SaveButton(
                        actionFunc: {
                            viewModel.objectWillChange.send()
                            showingAlert = !viewModel.courseHasName(course.id);
                            if !showingAlert {
                                self.needRefresh.toggle()
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    )
                    .alert("Oops!", isPresented: $showingAlert) {
                        Text("Please add a name.")
                        Button("OK", role: .cancel) { }
                    }
                }
                .navigationBarBackButtonHidden()
                .navigationBarItems(
                    leading: Text(title)
                        .font(.system(size:36, weight: .bold)),
                    trailing: Button(
                        action: {
                            // Make sure we don't save an empty course.
                            if isNew {
                                viewModel.removeCourse(course.id)
                            }
                            self.presentationMode.wrappedValue.dismiss()
                        },
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
}
