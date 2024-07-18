//
//  CourseCreateView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/16/24.
//

import SwiftUI

struct CourseCreateView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel:AppViewModel;
    
    @State private var showingAlert = false
    @ObservedObject private var course:WrappedStruct<Course>;
    
    init(mealId:String) {
        // Note: Code smell to set state here, but I am unwilling to relax immutability of mealId in Course.
        _course = ObservedObject(wrappedValue: WrappedStruct(withItem:Course(mealId: mealId)))
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollForm {
                    PictureSubViews.CoursePictureNameRatingEditView(
                        name:$course.item.name,
                        picture:$course.item.pickedImage,
                        rating:$course.item.rating
                    )
                    DateSubViews.DatePickerSection(selectedDate:$course.item.date)
                    PictureSubViews.PictureAndNotesEditSection(
                        title: SectionTitle.food,
                        data: $course.item.food
                    )
                    PictureSubViews.BeveragePictureAndNotesEditSection(
                        title: SectionTitle.beverage,
                        data: $course.item.beveragePairing,
                        sameAsPrev: $course.item.beveragePairing.sameAsPrevious
                    )
                }
                PrimaryButtonSubViews.EditViewPrimaryButtons(
                    cancelFunc: {
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    saveFunc: {
                        showingAlert = course.item.name.isEmpty;
                        if !showingAlert {
                            viewModel.saveEditedCourse(course.item)
                            presentationMode.wrappedValue.dismiss()
                        }
                    },
                    fieldName: "name",
                    showingAlert: $showingAlert
                )
            }
            .navigationBarBackButtonHidden()
            .navigationBarItems(
                leading: StyledTitleText(ViewTitle.createCourse)
            )
        }
    }
}

