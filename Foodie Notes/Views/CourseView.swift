//
//  CourseView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/30/24.
//

import SwiftUI

struct CourseView: View {
    @Environment(\.dismiss) private var dismiss
    
    // TODO: This should be passed in.
    private let course = CoursesViews.testCourses[1];
        
    var body: some View {
        // TODO: Split my custom NavigationStack out into a custom view.
        NavigationStack {
            content
            .navigationBarBackButtonHidden()
            .navigationBarItems(
                leading: Text("View Course")
                    .font(.system(size:36, weight: .bold)),
                trailing: HStack {
                    NavigationLink(destination: CourseCreateOrEditView()) {
                        Image(systemName: "pencil")
                            .resizable()
                            .padding(6)
                            .frame(width: 24, height: 24)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .foregroundColor(.white)
                    }
                    Button(
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
                })
        }
    }
    
    var content: some View {
        // TODO: Pass in actual model values.
        Form {
            CoursesViews.CourseNameAndPickedImageView(course)
            DateViews.DateSection(course.date)           
            PictureViews.PictureAndNotesViewSection(title: "Food", data: course.food)
            if let wine = course.wine {
                PictureViews.PictureAndNotesViewSection(title: "Wine", data: wine)
            }
        }
    }
}

#Preview {
    CourseView()
}
