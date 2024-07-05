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

    @Binding var needRefresh: Bool;
    
    let courseId:String;
    let mealId:String;
    
    var body: some View {
        let course = viewModel.getCourseFor(courseId);
        // TODO: Split my custom NavigationStack out into a custom view.
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollForm {
                    CourseSubViews.CourseNameAndPickedImageView(mealId:course.mealId, course: course)
                    DateViews.DateSection(course.date)
                    PictureSubViews.PictureAndNotesViewSection(title: "Food", data: course.food)
                    if viewModel.checkShow(course.wine) {
                        PictureSubViews.PictureAndNotesViewSection(title: "Wine", data: course.wine)
                    }
                }
                ViewScreenPrimaryButtons(
                    backFunc: {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    editDest: CourseCreateOrEditView(
                        needRefresh:$needRefresh,
                        mealId:mealId,
                        courseId:course.id)
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
