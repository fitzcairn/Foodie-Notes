//
//  CourseAddOrEditView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI

struct CourseAddOrEditView: View {
    @Environment(\.dismiss) private var dismiss

    @State var name: String = ""
    @State var isHidden: Bool = false
    @State var email: String = ""
    @State var receiveEmails: Bool = false
    @State private var index = 0
    var emailOptions = ["All", "Transactional", "Marketing"]
    @State var volumeSliderValue: Double = 0
    @State var date = Date()
    @State var stepper: Int = 0
    
    
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
        Form {
            DatePickerSection(prompt:"When Enjoyed:")
            PictureAndAnnotationSection(title:"Food")
            PictureAndAnnotationSection(title:"Wine")
            NotesSection(title:"Additional Notes")
        }
    }
}

#Preview {
    CourseAddOrEditView()
}

