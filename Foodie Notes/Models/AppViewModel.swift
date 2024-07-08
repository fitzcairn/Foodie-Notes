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

                                              
    // MARK: - Save/Load/Export functionality
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
    func exportAsString(_ meal:Meal) -> String {
        var str = """
I ate \(meal.courses.count) courses during a meal at \(meal.venue.name) on \(meal.date.formatted(date: .complete, time: .omitted)).  I rated it \(meal.rating) stars.\n\n
"""
        if !meal.notes.isEmpty {
            str += "Overall, I thought: '\(meal.notes)'\n\n"
        }
        if !meal.menu.notes.isEmpty {
            str += "My notes on the menu were: '\(meal.menu.notes)'\n\n"
        }
 
        if (!meal.courses.isEmpty) {
            str += "Here are my notes for each course:\n"
            for (index, course) in meal.courses.enumerated() {
                str += "  Course \(index + 1) was named \(course.name), and rated it \(course.rating) stars\n"
                if (!course.food.notes.isEmpty) {
                    str += "  My thoughts on the dish: '\(course.food.notes)'\n"
                }
                if (!course.beveragePairing.notes.isEmpty) {
                    str += "  My thoughts on the beverage pairing: '\(course.food.notes)'\n"
                }
            }
        }
        return str;
    }

    
    // MARK: - View State Management
    func setMealBeingViewed(_ meal:Meal) {
        self.mealBeingViewed = meal;
    }
    func beginEditingMeal(_ mealId:String?) {
        self.mealBeingEdited = getMealFor(mealId) ?? Meal()
        isEditingMeal = true;
    }
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
    func addMeal(_ meal:Meal) {
        return model.addMeal(meal)
    }
    func addEmptyMeal() -> Meal {
        let meal = Meal()
        model.addMeal(meal)
        return meal;
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

   
    // MARK: - Meal Property Getter/Setters
    func setMealPickedPictureFor(_ mealId:String, img:Picture) {
        model.setMealPickedPictureFor(mealId, img:img)
    }
    func getMealImageFor(_ mealId:String) -> Picture? {
        guard let meal = model.getMealFor(mealId) else { return nil }
        return getMealImageFor(meal)
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
    func getMealRatingFor(_ mealId:String) -> Int? {
        model.getMealRatingFor(mealId)
    }
    func setMealRatingFor(_ mealId:String, rating:Int) {
        model.setMealRatingFor(mealId, rating:rating)
    }
    func setVenueNameFor(_ mealId:String, name:String) {
        model.setVenueNameFor(mealId, name:name)
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
    func getCourseFor(_ courseId:String) -> Course? {
        return model.getCourseFor(courseId);
    }
    func getCoursesFor(_ mealId:String) -> [Course] {
        return model.getCoursesFor(mealId)
    }
    func addCourseTo(_ mealId:String, course:Course) {
        model.addCourseTo(mealId, course:course)
    }
    func addNewCourseTo(_ mealId:String) -> Course {
        return model.addNewCourseTo(mealId)
    }
    func courseHasName(_ courseId:String) -> Bool {
        if let course = model.getCourseFor(courseId) {
            return course.name != ""
        }
        return false
    }
    func removeCourse(_ courseId:String) {
        model.removeCourse(courseId)
    }
    
    
    // MARK: - Course Property Getter/Setters
    func setCourseRatingFor(_ courseId:String, rating:Int) {
        model.setCourseRatingFor(courseId, rating:rating)
    }
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
    func setCourseNameFor(_ courseId:String, name:String) {
        model.setCourseNameFor(courseId, name:name)
    }
    func setCoursePickedPictureFor(_ courseId:String, img:Picture) {
        model.setCoursePickedPictureFor(courseId, img:img)
    }
    func setCourseDateFor(_ courseId:String, date:Date) {
        model.setCourseDateFor(courseId, date:date)
    }
    func setCourseFoodFor(_ courseId:String, food:PicturesAndNotes) {
        model.setCourseFoodFor(courseId, food:food)
    }
    func setCourseBeveragePairingFor(_ courseId:String, pairing:PicturesAndNotes) {
        model.setCourseBeveragePairingFor(courseId, pairing:pairing)
    }
    
    
    // MARK: - Other Useful Helpers
    func isPictureEmpty(_ image:Picture?) -> Bool {
        return image == nil || image!.url == nil || image!.deleted
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
