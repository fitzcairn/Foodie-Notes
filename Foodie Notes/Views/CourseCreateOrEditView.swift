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
    let mealId:String;
    let courseId:String?;

    var body: some View {
        // We're either editing or creating a new meal in the model.
        var course = viewModel.getOrAddCourseFor(mealId: mealId, courseId:courseId)
        let courseId = course.id;
        var dirty = false;
        
        NavigationStack {
            ZStack(alignment: .bottom) {
                Form {
                    PictureViews.PictureAndNameEditView(
                        name:Binding<String>(
                            get: { course.name },
                            set: { course.name = $0; dirty.toggle() }),
                        picture:Binding<AppModel.Picture>(
                            get: { course.pickedImage },
                            set: { course.pickedImage = $0; dirty.toggle() })
                    )
                    DateViews.DatePickerSection(
                        selectedDate: Binding<Date>(
                            get: { course.date },
                            set: { course.date = $0; dirty.toggle() })
                    )
                    PictureViews.PictureAndNotesEditSection(
                        title: "Food",
                        data: Binding<AppModel.PicturesAndNotes>(
                            get: { course.food },
                            set: { course.food = $0; dirty.toggle() })
                    )
                    PictureViews.PictureAndNotesEditSection(
                        title: "Wine",
                        data: Binding<AppModel.PicturesAndNotes>(
                                get: { course.wine },
                                set: { course.wine = $0; dirty.toggle() })
                    )
                }

                SaveButton(
                    actionFunc: {
                        if dirty {
                            viewModel.setMealCourseFor(mealId, course: course)
                            print("Saving course id: \(courseId)\n    course: \(course)")
                        }
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

#Preview {
    CourseCreateOrEditView(mealId:"m1", courseId:"c1")
        .environmentObject(AppViewModel(numTestMeals:5))
}

