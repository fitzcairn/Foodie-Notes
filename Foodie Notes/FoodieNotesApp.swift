//
//  FoodieNotesApp.swift
//  Foodie Notes -- an app for taking notes on food!
//
//  Created by Steve Martin on 6/22/24.
//

import SwiftUI

@main
struct FoodieNotesApp: App {
    // TODO: Add/load data here, and get rid of the testing insert.
    @State var viewModel = AppViewModel(numTestMeals: 1);

    var body: some Scene {
        WindowGroup {
            MealListView()
                .environmentObject(viewModel)
        }
    }
}
