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
        let course = viewModel.getCourseFor(course.id)!
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollForm {
                    CourseSubViews.CourseNameAndPickedImageView(course:course)
                    DateSubViews.DateSection(course.date)
                    if viewModel.checkShow(course.food) {
                        PictureSubViews.PictureAndNotesViewSection(title: SectionTitle.food, data: course.food)
                    }
                    if viewModel.checkShow(course.beveragePairing) {
                        PictureSubViews.PictureAndNotesViewSection(title: SectionTitle.beverage, data: course.beveragePairing)
                    }
                }
                PrimaryButtonSubViews.CourseViewPrimaryButtons(
                    backClosure: {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    editCourseDest: CourseEditView(
                        course:Binding<Course>(
                            get: { viewModel.getCourseFor(course.id)! },
                            set: { viewModel.saveEditedCourse($0) }
                        )
                    )
                )
            }
            .navigationBarBackButtonHidden()
            .navigationBarItems(
                leading: StyledTitleText(ViewTitle.viewCourse)
            )
        }
    }
}
