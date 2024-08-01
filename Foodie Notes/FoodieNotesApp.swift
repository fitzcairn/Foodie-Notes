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
    @State private var networkService = NetworkService()

    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(viewModel)
                .environment(networkService)
        }
    }
}
