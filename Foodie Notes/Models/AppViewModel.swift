//
//  AppViewModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import Foundation

// View model for the app.
class AppViewModel : ObservableObject {
    var id = AppModel.Id.createId();
    
    typealias Meal = AppModel.Meal;
    typealias Picture = AppModel.Picture;
    typealias PicturesAndNotes = AppModel.PicturesAndNotes;
    typealias Course = AppModel.Course;
         
    // App model
    @Published var model: AppModel = createAppModel();
    
    // Any filters
    var filter:String = "";
    
    init() {
    }
    
    // Populate some test data.
    init(numTestMeals:Int) {
        model.addTestData(numTestMeals: numTestMeals)
    }
    

    // MARK: - Meal Management
    
    // TODO: Do we need all of these?
    
    func addMeal(_ venue:String?) -> Meal {
        return model.addMeal(at:venue ?? "")
    }
    func getMeals() -> [Meal] {
        // TODO: apply filter, for now return all.
        return model.getMeals();
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
    func setCoursePickedImageFor(_ course:Course, image:AppModel.Picture) {
        model.setCoursePickedImageFor(course.id, picture:image)
    }
    func setCourseDateFor(_ course:Course, date:Date) {
        updateCoursesHelper(course) { oldCourse in
            var newCourse = oldCourse
            newCourse.date = newCourse.id == course.id ? date : oldCourse.date
            return newCourse
        }
    }
    func setCourseFoodFor(_ course:Course, food:AppModel.PicturesAndNotes) {
        updateCoursesHelper(course) { oldCourse in
            var newCourse = oldCourse
            newCourse.food = newCourse.id == course.id ? removeDeletedImagesFor(food) : oldCourse.food
            return newCourse
        }
    }
    func setCourseWineFor(_ course:Course, wine:AppModel.PicturesAndNotes) {
        updateCoursesHelper(course) { oldCourse in
            var newCourse = oldCourse
            newCourse.wine = newCourse.id == course.id ? removeDeletedImagesFor(wine) : oldCourse.wine
            return newCourse
        }
    }
    
    
    // MARK: - Useful Helpers
    func updatePickedPicturesFor(_ meal:Meal) {
        func isEmpty(_ image:Picture?) -> Bool {
            return image == nil || image!.src == nil || image!.deleted
        }

        // Update picked images for every course.
        if !meal.courses.isEmpty {
            for course in meal.courses {
                if !course.wine.pictures.isEmpty || !course.food.pictures.isEmpty {
                    setCoursePickedImageFor(course,
                                            image: (course.food.pictures + course.wine.pictures).first!)
                }
            }
        }
        
        // Ok, let's pick one.  Setup...
        func setAndGo(_ image:Picture) {
            var newMeal = meal
            newMeal.pickedImage = image
            model.updateMeal(meal.id, meal:newMeal);
        }
        
        // First: any courses?
        if !meal.courses.isEmpty {
            // First picked course picture we find.
            for course in meal.courses {
                if (!isEmpty(course.pickedImage)) {
                    return setAndGo(course.pickedImage)
                }
            }
        }
        // ... Followed by first menu picture we find.
        for img in meal.menu.pictures {
            if (!isEmpty(img)) {
                return setAndGo(img)
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
    func checkShow(_ pictureAndNotes:AppModel.PicturesAndNotes) -> Bool {
        return !pictureAndNotes.notes.isEmpty || !pictureAndNotes.pictures.isEmpty
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
        
        //print("!! AFTER, meal \(newMeal.id): \(newMeal.courses.map() { "\($0.id): \($0.name)" })")

        
        model.updateMeal(meal.id, meal:newMeal);
    }

    
    // MARK: - Factories
    private static func createAppModel() -> AppModel {
        // Very simple for now, keeping this factory in case any new init is needed later.
        return AppModel();
    }
}
