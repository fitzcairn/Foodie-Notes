//
//  MealCreateOrEditView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI

struct MealCreateOrEditView: View {
    @EnvironmentObject var viewModel:AppViewModel;
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        // TODO: Split my custom NavigationStack out into a custom view.
        NavigationStack {
            ZStack(alignment: .bottom) {
                form
                SaveButton()
            }
            .navigationBarBackButtonHidden()
            .navigationBarItems(
                leading: Text("Edit Meal")
                    .font(.system(size:36, weight: .bold)),
                trailing: HStack {
                    Button(
                        action: {
                            dismiss
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
    
    var form: some View {
        Form {
            LocationViews.LocationEditSection(venue:.constant(""))
            DateViews.DatePickerSection()
            PictureViews.PictureAndNotesEditSection(title: "Menu[s]", data:nil)
            CoursesViews.CoursesEditSection()
            NotesViews.NotesEditSection(title:"Additional Notes")
        }
    }

}

#Preview {
    MealCreateOrEditView()
        .environmentObject(AppViewModel(numTestMeals:5))
}
