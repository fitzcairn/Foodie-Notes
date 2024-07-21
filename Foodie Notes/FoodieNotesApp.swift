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
    @StateObject private var locationService  = LocationService()
    @StateObject private var webFetchService  = WebFetchService()

    var body: some Scene {
        WindowGroup {
            MealListView() {
                Task {
                    do {
                        try await ModelIOService.save(model: viewModel.model)
                    } catch {
                        // Blow up
                        fatalError(error.localizedDescription)
                    }
                }
            }
            .environmentObject(viewModel)
            .environmentObject(locationService)
            .environmentObject(webFetchService)
        }
    }
}
