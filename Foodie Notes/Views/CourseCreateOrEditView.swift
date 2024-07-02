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
    let course:Course?;

    var body: some View {
        // We're either editing or creating a new meal in the model.
        var newCourse = course ?? Course(mealId: self.mealId);
        var dirty = false;
        
        NavigationStack {
            ZStack(alignment: .bottom) {
                Form {
                    PictureSubViews.PictureAndNameEditView(
                        name:Binding<String>(
                            get: { newCourse.name },
                            set: { newCourse.name = $0; dirty = true }),
                        picture:Binding<AppModel.Picture>(
                            get: { newCourse.pickedImage },
                            set: { newCourse.pickedImage = $0; dirty = true })
                    )
                    DateViews.DatePickerSection(
                        selectedDate: Binding<Date>(
                            get: { newCourse.date },
                            set: { newCourse.date = $0; dirty = true })
                    )
                    PictureSubViews.PictureAndNotesEditSection(
                        title: "Food",
                        data: Binding<AppModel.PicturesAndNotes>(
                            get: { newCourse.food },
                            set: {
                                print("set for Food")
                                newCourse.food = viewModel.removeDeletedImagesFor($0);
                                dirty = true
                            }
                        )
                    )
                    PictureSubViews.PictureAndNotesEditSection(
                        title: "Wine",
                        data: Binding<AppModel.PicturesAndNotes>(
                            get: { newCourse.wine },
                            set: { newCourse.wine = viewModel.removeDeletedImagesFor($0); dirty = true })
                    )
                }

                SaveButton(
                    destination: CourseView(course: newCourse),
                    actionFunc: {
                        print(dirty)
                        if dirty {
                            viewModel.objectWillChange.send()
                            if course != nil {
                                viewModel.updateCourseFor(mealId, course: newCourse)
                            } else {
                                viewModel.addCourseTo(mealId, course: newCourse)
                            }
                            print("Saved:\n-->course id: \(String(describing: newCourse.id))\n-->course: \(newCourse)")
                            
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
    CourseCreateOrEditView(mealId:"m1", course:AppViewModel(numTestMeals:5).getCourseFor("c1")!)
        .environmentObject(AppViewModel(numTestMeals:5))
}
