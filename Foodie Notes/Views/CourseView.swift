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
        // TODO: Split my custom NavigationStack out into a custom view.
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollForm {
                    CourseSubViews.CourseNameAndPickedImageView(mealId:mealId, course: viewModel.getCourseFor(courseId))
                    DateViews.DateSection(viewModel.getCourseFor(courseId).date)
                    PictureSubViews.PictureAndNotesViewSection(title: "Food", data: viewModel.getCourseFor(courseId).food)
                    if viewModel.checkShow(viewModel.getCourseFor(courseId).wine) {
                        PictureSubViews.PictureAndNotesViewSection(title: "Wine", data: viewModel.getCourseFor(courseId).wine)
                    }
                }
                ViewScreenPrimaryButtons(
                    backFunc: {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    editDest: CourseCreateOrEditView(
                        needRefresh:$needRefresh,
                        mealId:mealId,
                        courseId:courseId)
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
