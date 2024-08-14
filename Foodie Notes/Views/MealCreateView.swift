//
//  MealCreateView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/16/24.
//

import SwiftUI

struct MealCreateView: View {
    @Binding var meal:Meal
    
    var body: some View {
        MealView(meal: meal)
    }
}
