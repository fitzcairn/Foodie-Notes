//
//  AppViewModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import Foundation

// View model for the app.
class AppViewModel : ObservableObject {
    // Map card type to String.
    typealias Meal = AppModel.Meal;

    // App model
    @Published private var model: AppModel = createAppModel();
    
    // Any filters
    var filter:String = "";
    
    init() {
    }
    
    // Populate some test data.
    init(numTestMeals:Int) {
        model.addTestData(numTestMeals: numTestMeals)
    }
    
    // MARK: - Intents
    
    func getMeals() -> [Meal] {
        // TODO: apply filter, for now return all.
        return model.getMeals();
    }
    
    func getMealFor(_ mealId:String) -> Meal? {
        return model.getMealFor(mealId)
    }

    
    // MARK: - Factories

    private static func createAppModel() -> AppModel {
        // Very simple for now, keeping this factory in case any new init is needed later.
        return AppModel();
    }
}
