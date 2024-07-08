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

    let courseId:String;
    let mealId:String;
    
    var body: some View {
        // TODO: Split my custom NavigationStack out into a custom view.
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollForm {
                    CourseSubViews.CourseNameAndPickedImageView(mealId:mealId, courseId: courseId)
                    DateViews.DateSection(viewModel.getCourseFor(courseId)?.date)
                    PictureSubViews.PictureAndNotesViewSection(title: "Food", data: viewModel.getCourseFor(courseId)?.food)
                    if viewModel.checkShow(viewModel.getCourseFor(courseId)?.beveragePairing) {
                        PictureSubViews.PictureAndNotesViewSection(title: "Beverage Pairing", data: viewModel.getCourseFor(courseId)?.beveragePairing)
                    }
                }
                ViewScreenPrimaryButtons(
                    backClosure: {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    editDest: CourseCreateOrEditView(title:"Edit Course"),
                    editClosure: {
                        viewModel.setNewCourse(courseId: courseId, mealId: mealId)
                    }
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
