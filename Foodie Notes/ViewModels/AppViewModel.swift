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
    enum AppState { case loading, splash, list }

    var id = Id.createId();
    
    @Published var state = AppState.loading
    @Published var model: AppModel = AppModel()
    
    // MARK: - Model Management
    // Set initial app state.
    func fromLoad(model:AppModel) {
        self.model = model;
        // Skip a the splash screen for now.
        state = .list
    }
    // Mutation happened -- kick off a save.
    func writeOut() {
        Task {
            do {
                try await ModelIOService.saveAppModel(model: self.model)
            }
            self.triggerRefresh()
        }
    }
    func triggerRefresh() {
        self.objectWillChange.send()
    }

    
    // MARK: - Meal Management
    func saveEditedMealFor(_ meal:Meal) {
        model.index(meal)
        writeOut()
    }
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
        writeOut()
    }
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
    func saveEditedCourse(_ course:Course) {
        model.indexCourse(course)
        writeOut()
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
        return image == nil || image!.photo == nil || image!.deleted
    }
    // Consolidate business logic on when to show a section.
    func checkShow(_ pictureAndNotes:PicturesAndNotes?) -> Bool {
        return pictureAndNotes != nil &&
                (!pictureAndNotes!.notes.isEmpty ||
                 !pictureAndNotes!.pictures.isEmpty ||
                 pictureAndNotes!.sameAsPrevious != nil && pictureAndNotes!.sameAsPrevious!)
    }
        
    // MARK: - Factories
    private static func createAppModel() -> AppModel {
        // Very simple for now, keeping this factory in case any new init is needed later.
        return AppModel();
    }
}
