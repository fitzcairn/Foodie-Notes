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

    var course:Course
    
    var body: some View {
        // TODO: this course should be a binding.
        //let course = viewModel.getCourseFor(course.id)!
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollForm {
                    CourseSubViews.CourseNameAndPickedImageView(course:course)
                    DateViews.DateSection(course.date)
                    PictureSubViews.PictureAndNotesViewSection(title: "Food", data: course.food)
                    if viewModel.checkShow(course.beveragePairing) {
                        PictureSubViews.PictureAndNotesViewSection(title: "Beverage Pairing", data: course.beveragePairing)
                    }
                }
                ViewScreenPrimaryButtons(
                    backClosure: {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    editDest: CourseCreateOrEditView(title:"Edit Course",
                                                     course:Binding<Course>(
                                                        get: { viewModel.getCourseFor(course.id)! },
                                                        set: { viewModel.saveEditedCourse($0) }
                                                     )
                                                    )
                )
            }
            .navigationBarBackButtonHidden()
            .navigationBarItems(
                leading: Text("View Course")
                    .font(.system(size:36, weight: .bold))
            )
        }
    }
}
