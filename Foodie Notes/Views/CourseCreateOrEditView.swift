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
            let courseId = course.id
            
            NavigationStack {
                ZStack(alignment: .bottom) {
                    ScrollForm {
                        PictureSubViews.PictureAndNameEditView(
                            name:Binding<String>(
                                get: { viewModel.getCourseFor(courseId).name },
                                set: { viewModel.setCourseNameFor(viewModel.getCourseFor(courseId), name: $0) }),
                            picture:Binding<Picture>(
                                get: { viewModel.getCourseFor(courseId).pickedImage },
                                set: { _ = $0 })
                        )
                        DateViews.DatePickerSection(
                            selectedDate: Binding<Date>(
                                get: { viewModel.getCourseFor(courseId).date },
                                set: { viewModel.setCourseDateFor(viewModel.getCourseFor(courseId), date:$0) })
                        )
                        PictureSubViews.PictureAndNotesEditSection(
                            title: "Food",
                            data: Binding<PicturesAndNotes>(
                                get: { viewModel.getCourseFor(courseId).food },
                                set: { viewModel.setCourseFoodFor(viewModel.getCourseFor(courseId), food:$0);
                                       viewModel.updatePickedPicturesFor(viewModel.getMealFor(mealId)!)}
                            )
                        )
                        PictureSubViews.PictureAndNotesEditSection(
                            title: "Wine",
                            data: Binding<PicturesAndNotes>(
                                get: { course.wine },
                                set: { viewModel.setCourseWineFor(viewModel.getCourseFor(courseId), wine:$0);
                                       viewModel.updatePickedPicturesFor(viewModel.getMealFor(mealId)!) })
                        )
                    }
                    EditScreenPrimaryButtons(
                        cancelFunc: {
                            // Make sure we don't save an empty course.
                            if isNew {
                                viewModel.removeCourse(course.id)
                            }
                            self.presentationMode.wrappedValue.dismiss()
                        },
                        saveFunc: {
                            viewModel.objectWillChange.send()
                            showingAlert = !viewModel.courseHasName(course.id);
                            if !showingAlert {
                                self.needRefresh.toggle()
                                presentationMode.wrappedValue.dismiss()
                            }
                        },
                        fieldName: "name",
                        showingAlert: $showingAlert
                    )
                }
                .navigationBarBackButtonHidden()
                .navigationBarItems(
                    leading: Text(title)
                        .font(.system(size:36, weight: .bold))
                )
            }
        }
    }
}
