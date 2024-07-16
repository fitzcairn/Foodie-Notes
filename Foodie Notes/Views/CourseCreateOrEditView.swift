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
    
    let title:String;
    @Binding var course:Course;
    
    @State private var showingAlert = false
        
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollForm {
                    PictureSubViews.PictureNameRatingEditView(
                        name:$course.name,
                        picture:$course.pickedImage,
                        rating:$course.rating
                    )
                    DateViews.DatePickerSection(selectedDate:$course.date)
                    PictureSubViews.PictureAndNotesEditSection(
                        title: "Food",
                        data: $course.food
                    )
                    PictureSubViews.PictureAndNotesEditSection(
                        title: "Beverage Pairing",
                        data: $course.beveragePairing
                    )
                }
                PrimaryButtonSubViews.EditViewPrimaryButtons(
                    cancelFunc: {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    saveFunc: {
                        showingAlert = course.name.isEmpty;
                        if !showingAlert {
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

