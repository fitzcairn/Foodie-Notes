//
//  CourseEditView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI

struct CourseEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel:AppViewModel;
    
    @Binding var course:Course;
    
    @State private var showingAlert = false
        
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollForm {
                    PictureSubViews.CoursePictureNameRatingEditView(
                        name:$course.name,
                        picture:$course.pickedImage,
                        rating:$course.rating
                    )
                    DateSubViews.DatePickerSection(selectedDate:$course.date)
                    PictureSubViews.PictureAndNotesEditSection(
                        title: SectionTitle.food,
                        data: $course.food
                    )
                    PictureSubViews.BeveragePictureAndNotesEditSection(
                        title: SectionTitle.beverage,
                        infoLink: $course.beveragePairing.infoLink,
                        data: $course.beveragePairing,
                        sameAsPrev: $course.beveragePairing.sameAsPrevious
                    )
                }
                PrimaryButtonSubViews.EditViewPrimaryButtons(
                    cancelFunc: {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    saveFunc: {
                        showingAlert = course.name.isEmpty;
                        if !showingAlert {
                            viewModel.saveEditedCourse(course)
                            presentationMode.wrappedValue.dismiss()
                        }
                    },
                    fieldName: "name",
                    showingAlert: $showingAlert
                )
            }
            .navigationBarBackButtonHidden()
            .navigationBarItems(
                leading: StyledTitleText(ViewTitle.editCourse)
            )
        }
    }
}
