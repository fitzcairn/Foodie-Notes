//
//  AppModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import Foundation

// Backend model for global app state.
struct AppModel : Codable, Equatable {
    // All top-level storage.  Yes, there is duplication here.
    private var mealsById:[String:Meal] = [:];
    private var venuesByName:[String:Venue] = [:];
    private var coursesById:[String:Course] = [:];
    
    var showSplash:Bool = true;
    
    // MARK: - Meal Management
    mutating func removeMeal(_ mealId:String) {
        if let _ = mealsById[mealId] {
            for course in getCoursesFor(mealId) {
                coursesById.removeValue(forKey: course.id)
            }
            mealsById.removeValue(forKey: mealId)
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
    func getCourseFor(_ courseId:String) -> Course? {
        // If we get a bad course ID, crash.
        return coursesById[courseId];
    }
    func getCoursesFor(_ mealId:String) -> [Course] {
        if let meal = getMealFor(mealId) {
            return meal.courses
        }
        return []
    }
    mutating func index(_ meal:Meal) {
        let _ = getOrAddVenue(meal.venue.name);
        mealsById[meal.id] = meal;
        for course in meal.courses {
            coursesById[course.id] = course;
        }
    }
    mutating func indexCourse(_ course:Course) {
        guard(mealsById[course.mealId] != nil) else {return}

        // Do we know about this course?
        if coursesById[course.id] == nil {
            // Add to index.
            mealsById[course.mealId]!.courses.append(course)
            coursesById[course.id] = course
        } else {
            // Replace in the meal and index.
            coursesById[course.id] = course
            if let index = mealsById[course.mealId]!.courses.firstIndex(where: {$0.id == course.id}) {
                mealsById[course.mealId]!.courses[index] = course;
            }
        }
    }
    
    // MARK: - Private Members
    private mutating func getOrAddVenue(_ name:String?) -> Venue {
        let name = name ?? "";
        if let venue = venuesByName[name] {
            return venue
        }
        let newVenue = Venue(name);
        venuesByName[name] = newVenue;
        return newVenue;
    }

}
