//
//  FoodieNotesApp.swift
//  Foodie Notes -- an app for taking notes on food!
//
//  Created by Steve Martin on 6/22/24.
//

import SwiftUI

@main
struct FoodieNotesApp: App {
    let persistenceController = PersistenceController.shared
    
    @State var viewModel = AppViewModel(numTestMeals: 1);

    var body: some Scene {
        WindowGroup {
        //    ContentView()
        //        .environment(\.managedObjectContext, persistenceController.container.viewContext)
            MealListView()
                .environmentObject(viewModel)
        }
    }
}
