//
//  FoodieNotesApp.swift
//  Foodie Notes -- an app for taking notes on food!
//
//  Created by Steve Martin on 6/22/24.
//

import SwiftUI

@main
struct FoodieNotesApp: App {
    @StateObject private var viewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            MealListView() {
                Task {
                    do {
                        try await viewModel.save()
                    } catch {
                        // Blow up
                        fatalError(error.localizedDescription)
                    }
                }
            }
            .environmentObject(viewModel)
            
        }
    }
}
