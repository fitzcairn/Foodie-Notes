//
//  MealCreateOrEditView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI

struct MealCreateOrEditView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        // TODO: Split out into a custom view.
        NavigationStack {
            form
            .navigationBarBackButtonHidden()
            .navigationBarItems(
                leading: Text("Edit Meal")
                    .font(.system(size:36, weight: .bold)),
                trailing: HStack {
                    NavigationLink(destination: MealCreateOrEditView()) {
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
                            print("click!")
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
            DatePickerSection(prompt:"When Enjoyed:")
            PictureAndAnnotationSection(title:"Food")
            PictureAndAnnotationSection(title:"Wine")
            NotesSection(title:"Additional Notes")
        }
    }

}

#Preview {
    MealCreateOrEditView()
}
