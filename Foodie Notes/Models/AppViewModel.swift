//
//  AppViewModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import Foundation

// View model for the app.
@MainActor
class AppViewModel : ObservableObject {
    var id = Id.createId();
    
    enum AppState { case loading, splash, list }
    @Published var state = AppState.loading

    // App model
    @Published var model: AppModel = AppModel()
    
    // State for editing a meal.
    @Published var mealBeingViewed: Meal = Meal()
    @Published var mealBeingEdited: Meal = Meal()
    @Published var courseBeingEdited: Course = Course(mealId: "") // Hack
    @Published var isEditingMeal: Bool = false;

    
    func fromLoad(model:AppModel) {
        self.model = model;
        state = self.model.showSplash ? .splash : .list
    }
    
    
    // MARK: - View State Management
    func beginEditingMeal(_ meal:Meal) {
        self.mealBeingEdited = meal
        isEditingMeal = true;
    }
    func beginCreatingNewMeal() {
        self.mealBeingEdited = Meal()
        isEditingMeal = true;
    }
    func saveEditedMealFor(_ meal:Meal) {
        model.index(meal)
        isEditingMeal = false;
    }

    func setNewCourse(courseId:String?, mealId:String) {
        self.courseBeingEdited = courseId == nil ? Course(mealId: mealId) : getCourseFor(courseId!) ?? Course(mealId: mealId)
    }
    func setNewCourse(_ course:Course) {
        self.courseBeingEdited = course;
    }
    func updateMealBeingEditedlWith(_ course:Course) {
        guard(isEditingMeal) else { return }
        mealBeingEdited = model.getUpdatedMealWithCourse(meal: mealBeingEdited, course:course)
    }
    func saveEditedCourse() {
        guard(!self.courseBeingEdited.mealId.isEmpty) else {return}
        model.indexCourse(self.courseBeingEdited)
    }

    
    // MARK: - Meal Management
    func getMeals() -> [Meal] {
        // TODO: apply filter, for now return all.
        return model.getMeals().sorted(by: {$0.date > $1.date });
    }
    func getMealFor(_ mealId:String?) -> Meal? {
        return model.getMealFor(mealId)
    }
    func removeMeal(_ mealId:String?) {
        if let mealId = mealId {
            model.removeMeal(mealId)
        }
    }
   
    // MARK: - Meal Property Getter/Setters
    func getMealImageFor(_ meal:Meal) -> Picture? {
        // Do we have a manually picked image already?
        if !isPictureEmpty(meal.pickedImage) { return meal.pickedImage }

        // First choice: any course picked images?
        for course in model.getMealFor(meal.id)!.courses {
            if !isPictureEmpty(course.pickedImage) { return course.pickedImage }
        }
        
        // ... Followed by first menu picture we find, if needed
        for img in meal.menu.pictures {
            if (!isPictureEmpty(img)) {
                return img;
            }
        }

        // ... Any pictures at all?
        for course in model.getMealFor(meal.id)!.courses {
            if !course.beveragePairing.pictures.isEmpty || !course.food.pictures.isEmpty {
                return (course.food.pictures + course.beveragePairing.pictures).filter() { !isPictureEmpty($0) }.first ?? nil
            }
        }
        
        // None!
        return nil
    }

    
    // MARK: - Course Management
    func getCourseFor(_ courseId:String) -> Course? {
        return model.getCourseFor(courseId);
    }
    func addNewCourseTo(_ mealId:String) -> Course {
        return model.addNewCourseTo(mealId)
    }
    
    
    // MARK: - Course Property Getter/Setters
    func getCourseImageFor(_ courseId:String) -> Picture? {
        guard let course = model.getCourseFor(courseId) else { return nil }
        return getCourseImageFor(course)
    }
    func getCourseImageFor(_ course:Course) -> Picture? {
        // Do we have a manually picked image already?
        if !isPictureEmpty(course.pickedImage) { return course.pickedImage }
        
        // Any images?
        if !course.beveragePairing.pictures.isEmpty || !course.food.pictures.isEmpty {
            return (course.food.pictures + course.beveragePairing.pictures).filter() { !isPictureEmpty($0) }.first ?? nil
        }
        
        // None
        return nil;
    }
    
    
    // MARK: - Other Useful Helpers
    func isPictureEmpty(_ image:Picture?) -> Bool {
        return image == nil || image!.data == nil || image!.deleted
    }
    
    func removeDeletedImagesFor(_ old:PicturesAndNotes) -> PicturesAndNotes {
        var new = PicturesAndNotes(notes:old.notes)
        for picture in old.pictures {
            if !picture.deleted {
                new.pictures.append(picture)
            }
        }
        return new
    }
    // Consolidate business logic on when to show a section.
    func checkShow(_ pictureAndNotes:PicturesAndNotes?) -> Bool {
        return pictureAndNotes != nil && (!pictureAndNotes!.notes.isEmpty || !pictureAndNotes!.pictures.isEmpty)
    }
    
    // MARK: - Test Only
    func addTestData(numTestMeals:Int) {
        self.model.addTestData(numTestMeals: numTestMeals)
    }
    
    
    // MARK: - Factories
    private static func createAppModel() -> AppModel {
        // Very simple for now, keeping this factory in case any new init is needed later.
        return AppModel();
    }
}
