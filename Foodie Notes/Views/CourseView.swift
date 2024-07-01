//
//  CourseView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/30/24.
//

import SwiftUI

struct CourseView: View {
    @EnvironmentObject var viewModel:AppViewModel;
    let mealId:String;
    let courseId:String?;

    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>


    var body: some View {
        // TODO: Split my custom NavigationStack out into a custom view.
        NavigationStack {
            
            // TODO: Pass in actual model values.
            Form {
                CoursesViews.CourseNameAndPickedImageView(mealId:mealId, courseId: courseId)
                DateViews.DateSection(Date())
                //PictureViews.PictureAndNotesViewSection(title: "Food", data: course.food)
                //if let wine = course.wine {
                    //PictureViews.PictureAndNotesViewSection(title: "Wine", data: wine)
                //}
            }

            .navigationBarBackButtonHidden()
            .navigationBarItems(
                leading: Text("View Course")
                    .font(.system(size:36, weight: .bold)),
                trailing: HStack {
                    NavigationLink(destination: CourseCreateOrEditView(viewModel: viewModel, course: course)) {
                        Image(systemName: "pencil")
                            .resizable()
                            .padding(6)
                            .frame(width: 24, height: 24)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .foregroundColor(.white)
                    }
                    Button(
                        action: { self.presentationMode.wrappedValue.dismiss() },
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
}

#Preview {
    CourseView(mealId:"m1", courseId:"c1")
        .environmentObject(AppViewModel(numTestMeals:5))
}
