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
            let course = !isNew ? viewModel.getCourseFor(courseId!)! : viewModel.getLastCourseFor(mealId)!
            let courseId = course.id
            
            NavigationStack {
                ZStack(alignment: .bottom) {
                    ScrollForm {
                        PictureSubViews.PictureNameRatingEditView(
                            name:Binding<String>(
                                get: { viewModel.getCourseFor(courseId)?.name ?? "" },
                                set: { viewModel.setCourseNameFor(courseId, name: $0) }),
                            picture:Binding<Picture?>(
                                get: { viewModel.getCourseFor(courseId)?.pickedImage },
                                set: { viewModel.setCoursePickedPictureFor(courseId, img: $0!) }),
                            rating:Binding<Int>(
                                get: { viewModel.getCourseFor(courseId)?.rating ?? 0 },
                                set: { viewModel.setCourseRatingFor(courseId, rating: $0) })
                        )
                        DateViews.DatePickerSection(
                            selectedDate: Binding<Date>(
                                get: { viewModel.getCourseFor(courseId)?.date ?? Date() },
                                set: { viewModel.setCourseDateFor(courseId, date:$0) })
                        )
                        PictureSubViews.PictureAndNotesEditSection(
                            title: "Food",
                            data: Binding<PicturesAndNotes>(
                                get: { viewModel.getCourseFor(courseId)!.food },
                                set: { viewModel.setCourseFoodFor(courseId, food:$0 )}
                            )
                        )
                        PictureSubViews.PictureAndNotesEditSection(
                            title: "Beverage Pairing",
                            data: Binding<PicturesAndNotes>(
                                get: { viewModel.getCourseFor(courseId)!.beveragePairing },
                                set: { viewModel.setCourseBeveragePairingFor(courseId, pairing:$0) })
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
