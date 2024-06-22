//
//  Foodie_NotesApp.swift
//  Foodie Notes -- an app for taking notes on food!
//
//  Created by Steve Martin on 6/22/24.
//

import SwiftUI

@main
struct Foodie_NotesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
