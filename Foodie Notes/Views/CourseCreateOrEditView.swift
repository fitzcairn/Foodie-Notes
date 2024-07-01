//
//  CourseCreateOrEditView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI

struct CourseCreateOrEditView: View {
    @EnvironmentObject var viewModel:AppViewModel;
    let courseId:String?;

    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // TODO: fully hook up model.
                Form {
                    PictureViews.PictureAndNameEditView(viewModel: viewModel, name: .constant("whee"), image: .constant("plus"))
                    DateViews.DatePickerSection(selectedDate: Date())
                    PictureViews.PictureAndNotesEditSection(title: "Food", data: nil)
                    PictureViews.PictureAndNotesEditSection(title: "Wine", data: nil)
                }

                SaveButton() // TODO: Action to save this form
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
}

#Preview {
    CourseCreateOrEditView(courseId:"c1")
        .environmentObject(AppViewModel(numTestMeals:5))
}

