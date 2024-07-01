//
//  AppViewModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import Foundation

// View model for the app.
class AppViewModel : ObservableObject {
    typealias Meal = AppModel.Meal;
    typealias Course = AppModel.Course;
    
    private static var missingImage = "fork.knife.circle";

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
    
    func getCourseFor(id:String?) -> Course? {
        if let courseId = id {
            return model.getCourse(id:courseId);
        }
        return nil;
    }
    
    func addNewCourseTo(mealId:String) -> Course {
        return model.addCourseToMeal(mealId: mealId)
    }
    
    func getOrAddCourseFor(mealId:String, courseId:String?) -> Course {
        return getCourseFor(id: courseId) ?? addNewCourseTo(mealId:mealId)
    }
    
    func getMeals() -> [Meal] {
        // TODO: apply filter, for now return all.
        return model.getMeals();
    }
    
    func getMealFor(_ mealId:String) -> Meal? {
        return model.getMealFor(mealId)
    }
    
    func getPreferredImageSrc(for courseId:String, in mealId:String) -> String {
        if let course = getMealFor(mealId)?.courses.first(where: { $0.id == courseId }) {
            return getPreferredImageSrc(for: course)
        }
        return AppViewModel.missingImage;
    }
    
    func getPreferredImageSrc(for course:AppModel.Course) -> String {
        if let preferred = course.pickedImage {
            return preferred.src
        }
        return course.food.pictures.isEmpty ? AppViewModel.missingImage : course.food.pictures.randomElement()!.src;
    }

    
    // MARK: - Factories

    private static func createAppModel() -> AppModel {
        // Very simple for now, keeping this factory in case any new init is needed later.
        return AppModel();
    }
}
