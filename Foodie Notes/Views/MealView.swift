//
//  MealView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI

struct MealView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        // TODO: Split my custom NavigationStack out into a custom view.
        NavigationStack {
            content
            .navigationBarBackButtonHidden()
            .navigationBarItems(
                leading: Text("View Meal")
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
            // Location
            LocationViews.LocationViewSection(venue:"Bob's Shack", rating: 4)
            
            DateViews.DateSection(Date())

            // Courses!
            CoursesViews.CoursesViewSection()

            // Notes
            // TODO: condition on if there's a note.
            NotesViews.NotesSection(
                title:"Additional Notes",
                note: """
                In the below example, for each link is sent a string with the screen number, in the NavigationLink's value parameter. And then, the link's container has implemented the navigationDestination, that will be called when any value of type string, is sent.
                """
            )
        }
    }
}

#Preview {
    MealView()
}
