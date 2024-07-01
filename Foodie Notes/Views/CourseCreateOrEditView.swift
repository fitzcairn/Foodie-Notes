//
//  CourseCreateOrEditView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI

struct CourseCreateOrEditView: View {
    @Environment(\.dismiss) private var dismiss
    
    // TODO: This should be passed in.
    private let course = CoursesViews.testCourses[0];
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                form
                SaveButton()
            }
            .navigationBarBackButtonHidden()
            .navigationBarItems(
                leading: Text("Edit Course")
                    .font(.system(size:36, weight: .bold)),
                trailing: Button(
                    action: {
                        dismiss()
                    },
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
    
    var form: some View {
        // TODO: Pass in actual model values.
        Form {
            NameViews.NameAndImageEditView(name: .constant(course.name), image: .constant(course.pickedImage))
            DateViews.DatePickerSection(selectedDate:course.date)
            PictureViews.PictureAndNotesEditSection(title: "Food", data: course.food)
            PictureViews.PictureAndNotesEditSection(title: "Wine", data: course.wine)
        }
    }
}

#Preview {
    CourseCreateOrEditView()
}

