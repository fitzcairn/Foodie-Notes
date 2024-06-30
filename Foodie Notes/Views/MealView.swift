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
        NavigationStack {
            Text("View Meal")
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
}

#Preview {
    MealView()
}
