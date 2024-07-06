//
//  AppModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import Foundation
import ExyteMediaPicker


// Backend model for all app state.
struct AppModel { //}: Codable {
    // All top-level storage.  Yes, there is duplication here.
    private var mealsById:[String:Meal] = [:];
    private var venuesByName:[String:Venue] = [:];
    private var coursesById:[String:Course] = [:];
    private var lastNewMealCreatedId:String?;
    
    var skipSplash:Bool = true;
               
   
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
    mutating func setRatingFor(_ mealId:String, rating:Int) {
        if mealsById[mealId] != nil {
            mealsById[mealId]!.venue.rating = rating;
        }
    }
    mutating func setVenueFor(_ mealId:String, name:String) {
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
        let course = getCourseFor(courseId);
        if let meal = getMealFor(course.mealId) {
            mealsById[meal.id]!.courses = mealsById[meal.id]!.courses.filter() { $0.id != courseId}
            coursesById.removeValue(forKey: course.id)
        }
    }
    mutating func setCoursePickedImageFor(_ courseId:String, picture:Picture) {
        coursesById[courseId]?.pickedImage = picture;
    }
    mutating func setMealPickedImageFor(_ mealId:String, picture:Picture) {
        mealsById[mealId]?.pickedImage = picture;
    }

    
    // MARK: - Public Getter Intents
    
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
    func getCourseFor(_ courseId:String) -> Course {
        return coursesById[courseId]!;
    }
    func getCoursesFor(_ mealId:String) -> [Course] {
        if let meal = getMealFor(mealId) {
            return meal.courses
        }
        return []
    }
  
    
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
    private mutating func index(_ meal:Meal) {
        let _ = getOrAddVenue(meal.venue.name);
        mealsById[meal.id] = meal;
        for course in meal.courses {
            coursesById[course.id] = course;
        }
    }
}







// TODO: Remove
// For testing only.
extension AppModel {
    private mutating func addMeal(_ meal:Meal) {
        index(meal);
    }
    
    // Populate some test data.
    mutating func addTestData(numTestMeals:Int) {
        for index in 0..<numTestMeals {
            addMeal(
                Meal(
                    id: "m\(index)",
                    venue: Venue(name: "McDonalds", rating:4),
                    menu: PicturesAndNotes(
                        pictures: [
                        ],
                        notes: "An amazing menu populated by amazing deals!"),
                    courses: [
                        Course(id: "c1",
                               mealId: "m\(index)",
                               name: "Amuse Bouche",
                               date: Date(),
                               food: PicturesAndNotes(
                                pictures: [
                                ],
                                notes: "A delightful bite-sized explosion of flavors that sets the perfect tone for the culinary journey ahead."),
                               wine: PicturesAndNotes()
                              ),
                        Course(id: "c2",
                               mealId: "m\(index)",
                               name: "Lobster",
                               date: Date(),
                               food: PicturesAndNotes(
                                pictures: [
                                ],
                                notes: "A succulent lobster dish that boasts tender, buttery meat perfectly complemented by a rich, flavorful sauce."),
                               wine:PicturesAndNotes()
                              ),
                        Course(id: "c3",
                               mealId: "m\(index)",
                               name: "Veal",
                               date: Date(),
                               food: PicturesAndNotes(
                                pictures: [
                                ],
                                notes: "A tender veal dish with a delicate balance of flavors, offering a melt-in-your-mouth experience."),
                               wine: PicturesAndNotes(
                                pictures: [
                                ],
                                notes: "A masterful wine pairing that elevates each dish, enhancing flavors and creating a harmonious dining experience.")
                              ),
                        Course(id: "c4",
                               mealId: "m\(index)",
                               name: "Amuse Bouche",
                               date: Date(),
                               food: PicturesAndNotes(
                                pictures: [
                                    Picture(),
                                ],
                                notes: "Chocolate for days!"),
                               wine:PicturesAndNotes()
                              ),
                    ],
                    date: Date(),
                    notes: "A lovely meal with amazingly mature cheese on the Big Mac."
                )
            )
        }
    }
}
