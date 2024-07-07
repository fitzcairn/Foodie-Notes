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
    
    // Any filters
    var filter:String = "";
    
       
    // MARK: - Save/Load functionality

    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("appmodel.data")
    }
    
    func load() async throws {
        let task = Task<AppModel, Error> {
            let fileURL = try AppViewModel.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return AppModel()
            }
            let appModel = try JSONDecoder().decode(AppModel.self, from: data)
            return appModel
        }
        let appModel = try await task.value
        self.model = appModel
        state = self.model.showSplash ? .splash : .list
    }
    
    func save() async throws {
        let task = Task {
            let data = try JSONEncoder().encode(model)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
    
    
    // MARK: - Meal Management
    func addMeal(_ venue:String?) -> Meal {
        return model.addMeal(at:venue ?? "")
    }
    func getMeals() -> [Meal] {
        // TODO: apply filter, for now return all.
        return model.getMeals().sorted(by: {$0.date > $1.date });
    }
    func getMealFor(_ mealId:String?) -> Meal? {
        return model.getMealFor(mealId)
    }
    func removeMeal(_ mealId:String) {
        model.removeMeal(mealId)
    }
    func mealHasVenue(_ mealId:String) -> Bool{
        if let meal = model.getMealFor(mealId) {
            return meal.venue.name != ""
        }
        return false;
    }
    // Royal hacks to use model state for new courses.
    func getLastCourseFor(_ mealId:String) -> Course? {
        return model.getCoursesFor(mealId).last;
    }
    func getLastNewMealCreated() -> Meal? {
        return model.getLastNewMealCreated();
    }

   
    // MARK: - Meal Property Setters
    func setRatingFor(_ mealId:String, rating:Int) {
        model.setRatingFor(mealId, rating:rating)
    }
    func setVenueFor(_ mealId:String, name:String) {
        model.setVenueFor(mealId, name:name)
    }
    func setDateFor(_ mealId:String, date:Date) {
        model.setDateFor(mealId, date:date)
    }
    func setMenuFor(_ mealId:String, menu:PicturesAndNotes) {
        let cleanMenu = removeDeletedImagesFor(menu);
        return model.setMenuFor(mealId, menu:cleanMenu)
    }
    func setNotesFor(_ mealId:String, notes:String) {
        return model.setNotesFor(mealId, notes:notes)
    }
    func setCoursesFor(_ mealId:String, courses:[Course]) {
        return model.setCoursesFor(mealId, courses:courses)
    }
    func setMealPickedImageFor(_ mealId:String, image:Picture) {
        model.setMealPickedImageFor(mealId, picture:image)
    }

    
    // MARK: - Course Management
    func getCourseFor(_ courseId:String) -> Course {
        return model.getCourseFor(courseId);
    }
    func getCoursesFor(_ mealId:String) -> [Course]? {
        if let meal = model.getMealFor(mealId) {
            return meal.courses;
        }
        return nil;
    }
    func addNewCourseTo(_ mealId:String) -> Course {
        return model.addNewCourseTo(mealId)
    }
    func courseHasName(_ courseId:String) -> Bool {
        return model.getCourseFor(courseId).name != ""
    }
    func removeCourse(_ courseId:String) {
        model.removeCourse(courseId)
    }
    
    
    // MARK: - Course Property Setters
    func setCourseNameFor(_ course:Course, name:String) {
        updateCoursesHelper(course) { oldCourse in
            var newCourse = oldCourse
            newCourse.name = newCourse.id == course.id ? name : oldCourse.name
            return newCourse
        }
    }
    func setCoursePickedImageFor(_ course:Course, image:Picture) {
        model.setCoursePickedImageFor(course.id, picture:image)
    }
    func setCourseDateFor(_ course:Course, date:Date) {
        updateCoursesHelper(course) { oldCourse in
            var newCourse = oldCourse
            newCourse.date = newCourse.id == course.id ? date : oldCourse.date
            return newCourse
        }
    }
    func setCourseFoodFor(_ course:Course, food:PicturesAndNotes) {
        updateCoursesHelper(course) { oldCourse in
            var newCourse = oldCourse
            newCourse.food = newCourse.id == course.id ? removeDeletedImagesFor(food) : oldCourse.food
            return newCourse
        }
    }
    func setCourseBeveragePairingFor(_ course:Course, beveragePairing:PicturesAndNotes) {
        updateCoursesHelper(course) { oldCourse in
            var newCourse = oldCourse
            newCourse.beveragePairing = newCourse.id == course.id ? removeDeletedImagesFor(beveragePairing) : oldCourse.beveragePairing
            return newCourse
        }
    }
    
    
    // MARK: - Useful Helpers
    func updatePickedPicturesFor(_ meal:Meal) {
        func isEmpty(_ image:Picture?) -> Bool {
            return image == nil || image!.url == nil || image!.deleted
        }

        // Update picked images for every course.
        if !meal.courses.isEmpty {
            for course in model.getMealFor(meal.id)!.courses {
                if !course.beveragePairing.pictures.isEmpty || !course.food.pictures.isEmpty {
                    let img:Picture = (course.food.pictures + course.beveragePairing.pictures).filter() { !isEmpty($0) }.first ?? course.pickedImage
                    setCoursePickedImageFor(course,
                                            image: img)
                    setMealPickedImageFor(meal.id, image: img)
                    return;
                }
            }
        }
        
        // ... Followed by first menu picture we find, if needed
        if isEmpty (model.getMealFor(meal.id)!.pickedImage) {
            for img in meal.menu.pictures {
                if (!isEmpty(img)) {
                    return setMealPickedImageFor(meal.id, image: img)
                }
            }
        }
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
    func checkShow(_ pictureAndNotes:PicturesAndNotes) -> Bool {
        return !pictureAndNotes.notes.isEmpty || !pictureAndNotes.pictures.isEmpty
    }
    
    
    // MARK: - Test Only

    func addTestData(numTestMeals:Int) {
        self.model.addTestData(numTestMeals: numTestMeals)
    }
    

    
    // MARK: - Private Helper Intents
    
    // Yuck but efficiency via ID referencing is complicated. Should be small copying.
    private func updateCoursesHelper(_ course:Course, update:((Course) -> Course)) {
        let meal = model.getMealFor(course.mealId)!
        var newCourses:[Course] = []
        for oldCourse in meal.courses {
            newCourses.append(update(oldCourse))
        }
        var newMeal = meal
        newMeal.courses = newCourses;
        model.updateMeal(meal.id, meal:newMeal);
    }

    
    // MARK: - Factories
    private static func createAppModel() -> AppModel {
        // Very simple for now, keeping this factory in case any new init is needed later.
        return AppModel();
    }
}
