//
//  AppModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import Foundation
import ExyteMediaPicker


// Backend model for all app state.
struct AppModel : Codable {
    // All top-level storage.  Yes, there is duplication here.
    private var mealsById:[String:Meal] = [:];
    private var venuesByName:[String:Venue] = [:];
    private var coursesById:[String:Course] = [:];
    private var lastNewMealCreatedId:String? = nil;
    
    var showSplash:Bool = true;
    
    // MARK: - Meal Management
    mutating func addMeal(at venueName:String?) -> Meal {
        let venue = getOrAddVenue(venueName);
        return addMeal(at:venue);
    }
    mutating func addMeal(at venue:Venue) -> Meal {
        let meal = Meal(venue: venue);
        index(meal)
        lastNewMealCreatedId = meal.id;
        return meal;
    }
    mutating func removeMeal(_ mealId:String) {
        if let _ = mealsById[mealId] {
            for course in getCoursesFor(mealId) {
                coursesById.removeValue(forKey: course.id)
            }
            mealsById.removeValue(forKey: mealId)
        }
        if (lastNewMealCreatedId == mealId) {
            lastNewMealCreatedId = nil;
        }
    }
    func getMeals() -> [Meal] {
        return Array(mealsById.values).sorted { $0.date > $1.date }
    }
    func getMealFor(_ mealId:String?) -> Meal? {
        if let mealId = mealId {
            return mealsById[mealId]
        }
        return nil;
    }
    func getLastNewMealCreated() -> Meal? {
        return getMealFor(lastNewMealCreatedId);
    }
    // If we get a bad course ID, crash.
    func getCourseFor(_ courseId:String) -> Course? {
        return coursesById[courseId];
    }
    func getCoursesFor(_ mealId:String) -> [Course] {
        if let meal = getMealFor(mealId) {
            return meal.courses
        }
        return []
    }
    // Index a meal.
    mutating func index(_ meal:Meal) {
       let _ = getOrAddVenue(meal.venue.name);
       mealsById[meal.id] = meal;
       for course in meal.courses {
           coursesById[course.id] = course;
       }
   }
    mutating func setMealRatingFor(_ mealId:String, rating:Int) {
        if mealsById[mealId] != nil {
            mealsById[mealId]!.rating = rating;
        }
    }
    
    // MARK: - Meal Property Getter/Setters
    mutating func setMealPickedPictureFor(_ mealId:String, img:Picture) {
        if mealsById[mealId] != nil {
            mealsById[mealId]!.pickedImage = img;
        }
    }
    mutating func setVenueNameFor(_ mealId:String, name:String) {
        if mealsById[mealId] != nil {
            mealsById[mealId]!.venue.name = name;
        }
    }
    mutating func setDateFor(_ mealId:String, date:Date) {
        if mealsById[mealId] != nil {
            mealsById[mealId]!.date = date;
        }
    }
    mutating func setNotesFor(_ mealId:String, notes:String) {
        if mealsById[mealId] != nil {
            mealsById[mealId]!.notes = notes;
        }
    }
    mutating func setMenuFor(_ mealId:String, menu:PicturesAndNotes) {
        if mealsById[mealId] != nil {
            mealsById[mealId]!.menu = menu
        }
    }
    mutating func setCoursesFor(_ mealId:String, courses:[Course]) {
        if mealsById[mealId] != nil {
            mealsById[mealId]!.courses = courses
        }
    }
    mutating func updateMeal(_ mealId:String, meal:Meal) {
        index(meal)
    }
    mutating func addCourseTo(_ mealId:String, course:Course) {
        if let meal = getMealFor(mealId) {
            mealsById[meal.id]!.courses.append(course)
            coursesById[course.id] = course
        }
    }
    mutating func addNewCourseTo(_ mealId: String) -> Course {
        let course = Course(mealId: mealId)
        addCourseTo(mealId, course: course)
        return course
    }
    mutating func removeCourse(_ courseId:String) {
        guard let course = getCourseFor(courseId) else { return }
        if let meal = getMealFor(course.mealId) {
            mealsById[meal.id]!.courses = mealsById[meal.id]!.courses.filter() { $0.id != courseId}
            coursesById.removeValue(forKey: courseId)
        }
    }
    func getMealRatingFor(_ mealId:String) -> Int? {
        return mealsById[mealId]?.rating
    }
    
    // MARK: - Course Property Getter/Setters
    mutating func setCourseRatingFor(_ courseId:String, rating:Int) {
        if coursesById[courseId] != nil {
            coursesById[courseId]!.rating = rating;
        }
    }
    mutating func setCourseNameFor(_ courseId:String, name:String) {
        if coursesById[courseId] != nil {
            coursesById[courseId]!.name = name;
        }
    }
    mutating func setCoursePickedPictureFor(_ courseId:String, img:Picture) {
        if coursesById[courseId] != nil {
            coursesById[courseId]!.pickedImage = img;
        }
    }
    mutating func setCourseDateFor(_ courseId:String, date:Date) {
        if coursesById[courseId] != nil {
            coursesById[courseId]!.date = date;
        }
    }
    mutating func setCourseFoodFor(_ courseId:String, food:PicturesAndNotes) {
        if coursesById[courseId] != nil {
            coursesById[courseId]!.food = food;
        }
    }
    mutating func setCourseBeveragePairingFor(_ courseId:String, pairing:PicturesAndNotes) {
        if coursesById[courseId] != nil {
            coursesById[courseId]!.beveragePairing = pairing;
        }
    }



    
    // MARK: - Public Getter Intents
    

  
    
    // MARK: - Private Members
    
    private mutating func getOrAddVenue(_ name:String?) -> Venue {
        let name = name ?? "";
        if let venue = venuesByName[name] {
            return venue
        }
        let newVenue = Venue(name:name);
        venuesByName[name] = newVenue;
        return newVenue;
    }

}
