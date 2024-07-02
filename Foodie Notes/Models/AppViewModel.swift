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
    typealias Picture = AppModel.Picture;
    typealias PicturesAndNotes = AppModel.PicturesAndNotes;
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
    
    func getOrAddPickedPictureFor(_ meal:Meal) -> Picture {
        func isEmpty(_ image:Picture) -> Bool {
            switch image.state {
                case .deleted, .empty:
                    return true
                case.filled:
                    return false
            }
        }

        // Check cache first.
        if (!isEmpty(meal.pickedImage)) {
            return meal.pickedImage
        }
        
        // Ok, let's pick one.  Setup...
        func setAndGo(_ image:Picture) -> Picture {
            var newMeal = meal
            newMeal.pickedImage = image
            updateMeal(meal.id, meal: newMeal)
            return image
        }
        
        // First: any courses?
        if !meal.courses.isEmpty {
            // First picked course picture we find.
            for course in meal.courses {
                if (!isEmpty(course.pickedImage)) {
                    return setAndGo(course.pickedImage)
                }
            }
            
            // ... Followed by first food or wine picture we find.
            for course in meal.courses {
                for img in course.food.pictures + course.wine.pictures {
                    if (!isEmpty(img)) {
                        return setAndGo(img)
                    }
                }
            }
        }
        // ... Followed by first menu picture we find.
        for img in meal.menu.pictures {
            if (!isEmpty(img)) {
                return setAndGo(img)
            }
        }
            
        // ... Give up, no pictures found!  Return the empty picture.
        return meal.pickedImage;
    }
    
    func getCourseFor(_ id:String?) -> Course? {
        if let courseId = id {
            return model.getCourse(id:courseId);
        }
        return nil;
    }
    
    func addNewCourseTo(_ mealId:String) -> Course {
        return model.addNewCourseTo(mealId)
    }
    
    func addCourseTo(_ mealId:String, course:Course) {
        model.addCourseTo(mealId, course:course)
    }
    
    func getOrAddCourseFor(mealId:String, courseId:String?) -> Course {
        return getCourseFor(courseId) ?? addNewCourseTo(mealId)
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
        if let course = getMealFor(mealId)?.courses.first(where: { $0.id == courseId }) {
            return getPreferredImageSrc(for: course)
        }
        return AppViewModel.missingImage;
    }
    
    func getPreferredImageSrc(for course:AppModel.Course) -> String {
        return course.pickedImage.src
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
    
    // Course updators --
    func updateCourseFor(_ mealId:String, course:Course) {
        updateCoursesHelper(course) { oldCourse in
            return oldCourse.id == course.id ? course : oldCourse
        }
    }
    
    func setCourseNameFor(_ course:Course, name:String) {
        updateCoursesHelper(course) { oldCourse in
            var newCourse = oldCourse
            newCourse.name = newCourse.id == course.id ? name : oldCourse.name
            return newCourse
        }
    }
    
    func setCoursePickedImageFor(_ course:Course, image:AppModel.Picture) {
        updateCoursesHelper(course) { oldCourse in
            var newCourse = oldCourse
            newCourse.pickedImage = newCourse.id == course.id ? image : oldCourse.pickedImage
            return newCourse
        }
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
            newCourse.food = newCourse.id == course.id ? food : oldCourse.food
            return newCourse
        }
    }
    
    func setCourseWineFor(_ course:Course, wine:AppModel.PicturesAndNotes) {
        updateCoursesHelper(course) { oldCourse in
            var newCourse = oldCourse
            newCourse.wine = newCourse.id == course.id ? wine : oldCourse.wine
            return newCourse
        }
    }
    
    func removeDeletedImagesFor(_ old:PicturesAndNotes) -> PicturesAndNotes {
        var new = PicturesAndNotes(notes:old.notes)
        for picture in old.pictures {
            if picture.state != AppModel.PictureState.deleted {
                new.pictures.append(picture)
            }
        }
        return new
    }
    

    func updateMeal(_ mealId:String, meal:Meal) {
        model.updateMeal(mealId, meal:meal);
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
        model.updateMeal(meal.id, meal:newMeal);
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
