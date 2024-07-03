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
    
    typealias Course = AppModel.Course
    
    let mealId:String;
    var courseId:String?

    var body: some View {
        // Rely on new courses getting created by tap event before view render.
        let course = courseId != nil ? viewModel.getCourseFor(courseId!) : viewModel.getLastCourseFor(mealId)
        
        NavigationStack {
            ZStack(alignment: .bottom) {
                Form {
                    PictureSubViews.PictureAndNameEditView(
                        name:Binding<String>(
                            get: { course.name },
                            set: { viewModel.setCourseNameFor(course, name: $0) }),
                        picture:Binding<AppModel.Picture>(
                            get: { course.pickedImage },
                            set: { viewModel.setCoursePickedImageFor(course, image:$0) })
                    )
                    DateViews.DatePickerSection(
                        selectedDate: Binding<Date>(
                            get: { course.date },
                            set: { viewModel.setCourseDateFor(course, date:$0) })
                    )
                    PictureSubViews.PictureAndNotesEditSection(
                        title: "Food",
                        data: Binding<AppModel.PicturesAndNotes>(
                            get: { course.food },
                            set: { viewModel.setCourseFoodFor(course, food:$0); }
                        )
                    )
                    PictureSubViews.PictureAndNotesEditSection(
                        title: "Wine",
                        data: Binding<AppModel.PicturesAndNotes>(
                            get: { viewModel.getCourseFor(course.id).wine },
                            set: { viewModel.setCourseWineFor(course, wine:$0) })
                    )
                }
                SaveButton(
                    actionFunc: {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
            .navigationBarBackButtonHidden()
            .navigationBarItems(
                leading: Text("Edit Course")
                    .font(.system(size:36, weight: .bold)),
                trailing: Button(
                    action: { self.presentationMode.wrappedValue.dismiss() },
                    label: {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.blue)
                    }
                )
            )
        }
    }
}
