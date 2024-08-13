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
    enum MealSortOrder { case name, dateAsc, dateDesc, location, rating, michelin }
    
    let id = Id.createId();
    
    @Published var state = AppState.loading
    @Published var model: AppModel = AppModel()
    
    // MARK: - Model Management
    func fromLoad(model:AppModel) {
        self.model = model;
        // Skip a the splash screen for now.
        state = .list
    }
    func writeOut() {
        Task {
            do {
                try await ModelIOService.saveAppModel(model: self.model)
            }
            self.objectWillChange.send()
        }
    }

    
    // MARK: - Meal Management
    func saveEditedMealFor(_ meal:Meal) {
        model.index(meal)
        writeOut()
    }
    func createMealAtVenue(_ venue:String) -> Meal {
        var meal = Meal()
        meal.venue = Venue(venue)
        saveEditedMealFor(meal)
        return meal;
    }
    func getMeals(filterText:String = "", sortOrder:MealSortOrder = .dateDesc) -> [Meal] {
        var meals = model.getMeals();
        
        if !filterText.isEmpty {
            meals = meals.filter() { $0.venue.name.range(of:filterText, options: .caseInsensitive) != nil }
        }
        
        switch(sortOrder) {
        case .name:
            return meals.sorted(by: {$0.venue.name < $1.venue.name });
        case .dateAsc:
            return meals.sorted(by: {$0.date < $1.date });
        case .dateDesc:
            return meals.sorted(by: {$0.date > $1.date });
        case .location:
            return meals.sorted(by: {$0.venue.location?.city ?? "" > $1.venue.location?.city ?? "" });
        case .rating:
            return meals.sorted(by: {$0.rating > $1.rating });
        case .michelin:
            return meals.sorted(by: {$0.venue.michelin ?? .none > $1.venue.michelin ?? .none });
        }
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
        guard(model.getMealFor(meal.id) != nil) else { return nil }
        let meal = model.getMealFor(meal.id)!
        
        // Do we have a manually picked image already?
        if !isPictureEmpty(meal.pickedImage) { return meal.pickedImage }

        // First choice: any course picked images?
        for course in meal.courses {
            if !isPictureEmpty(course.pickedImage) { return course.pickedImage }
        }
        
        // ... Followed by first menu picture we find, if needed
        for img in meal.menu.pictures {
            if (!isPictureEmpty(img)) {
                return img;
            }
        }

        // ... Any pictures at all?
        for course in meal.courses {
            if !course.beveragePairing.pictures.isEmpty || !course.food.pictures.isEmpty {
                return (course.food.pictures + course.beveragePairing.pictures).filter() { !isPictureEmpty($0) }.first ?? nil
            }
        }
        
        // None!
        return nil
    }
    func getAllImagesFor(_ meal:Meal) -> [Picture] {
        guard(model.getMealFor(meal.id) != nil) else { return [] }
        let meal = model.getMealFor(meal.id)!
        var images:[Picture] = []

        if !isPictureEmpty(meal.pickedImage) { images.append(meal.pickedImage!) }

        for course in meal.courses {
            if !isPictureEmpty(course.pickedImage) { images.append(course.pickedImage!) }
        }
        
        for img in meal.menu.pictures {
            if (!isPictureEmpty(img)) {
                images.append(img)
            }
        }

        for course in meal.courses {
            if !course.beveragePairing.pictures.isEmpty || !course.food.pictures.isEmpty {
                images += (course.food.pictures + course.beveragePairing.pictures).filter() { !isPictureEmpty($0) }
            }
        }
        return images
    }

    
    // MARK: - Course Management
    func getCourseFor(_ courseId:String) -> Course? {
        return model.getCourseFor(courseId);
    }
    func removeCourse(_ course:Course) {
        model.removeCourse(course)
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
}
