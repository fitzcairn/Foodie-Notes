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
    
    func getPictureFor(_ pictureId:String) -> Picture? {
        return model.getPictureFor(pictureId);
    }
    
    func getCourseFor(_ id:String?) -> Course? {
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
    
    func getMealFor(_ mealId:String?) -> Meal? {
        return model.getMealFor(mealId)
    }
    
    func getOrAddMealFor(_ mealId:String?) -> Meal {
        return model.getOrAddMealFor(mealId)
    }
    
    func setMenuFor(_ mealId:String, menu:AppModel.PicturesAndNotes) {
        return model.setMenuFor(mealId, menu:menu)
    }
    
    func setNotesFor(_ mealId:String, notes:String) {
        return model.setNotesFor(mealId, notes:notes)
    }
    
    func getPreferredImageSrc(for courseId:String, in mealId:String) -> String {
        if let course = getMealFor(mealId)?.courseIds.first(where: { $0.id == courseId }) {
            return getPreferredImageSrc(for: course)
        }
        return AppViewModel.missingImage;
    }
    
    func getPreferredImageSrc(for course:AppModel.Course) -> String {
        if let preferred = course.pickedImage {
            return preferred.src
        }
        return course.food.pictureIds.isEmpty ? AppViewModel.missingImage : course.food.pictureIds.randomElement()!.src;
    }
    
    func setVenueFor(_ mealId:String, venue:AppModel.Venue) {
        var meal = model.getOrAddMealFor(mealId);
        meal.venue = venue;
        model.updateMeal(mealId, meal:meal);
    }
    
    func setVenueNameFor(_ mealId:String, name:String) {
        var meal = model.getOrAddMealFor(mealId);
        meal.venue.name = name;
        model.updateMeal(mealId, meal:meal);
    }
    
    func setVenueRatingFor(_ mealId:String, rating:Int) {
        var meal = model.getOrAddMealFor(mealId);
        meal.venue.rating = rating;
        model.updateMeal(mealId, meal:meal);
    }
    
    func setCourseNameFor(_ course:Course, name:String) {
        model.
            .getCourse(id: course.id);
        meal.venue.rating = rating;
        model.updateMeal(mealId, meal:meal);
    }
    
    func updateMeal(_ mealId:String, meal:Meal) {
        model.updateMeal(mealId, meal:meal);
    }
    
    // Consolidate business logic on when to show a section.
    func checkShow(_ pictureAndNotes:AppModel.PicturesAndNotes) -> Bool {
        return !pictureAndNotes.notes.isEmpty || !pictureAndNotes.pictureIds.isEmpty
    }
    
    // MARK: - Factories
    private static func createPicturesAndNotes() -> AppModel.PicturesAndNotes {
        return AppModel.PicturesAndNotes()
    }

    private static func createAppModel() -> AppModel {
        // Very simple for now, keeping this factory in case any new init is needed later.
        return AppModel();
    }
}
