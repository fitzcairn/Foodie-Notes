//
//  AppModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import Foundation


// Backend model for all app state.
struct AppModel {
    private var mealsById:[String:Meal] = [:];
    private var venuesByName:[String:Venue] = [:];
    private var mealsByVenue:[String:[Meal]] = [:];
    private var coursedById:[String:Course] = [:];
        
    // MARK: - Public Intents
    
    mutating func addMeal(at venueName:String) -> Meal {
        let venue = getOrAddVenue(venueName);
        let meal = Meal(venue: venue);
        index(meal)
        return meal;
    }
    
    mutating func addCourseToMeal(mealId:String, course:Course) {
        if let _ = getMealFor(mealId) {
            mealsById[mealId]!.courses.append(course)
            coursedById[course.id] = course
        }
    }
    
    mutating func addCourseToMeal(mealId: String) -> Course {
        let course = Course(mealId: mealId)
        addCourseToMeal(mealId: mealId, course: course)
        return course
    }

    
    mutating func removeCourseFromMeal(mealId:String, at:Int) {
        if let _ = getMealFor(mealId) {
            mealsById[mealId]!.courses.remove(at: at)
        }
    }
    
    func getCourse(id:String) -> Course? {
        return coursedById[id];
    }
    
    func getMeals() -> [Meal] {
        return Array(mealsById.values).sorted { $0.date > $1.date }
    }
    
    func getMealFor(_ mealId:String) -> Meal? {
        return mealsById[mealId]
    }
    
    // MARK: - Private Members
    
    private mutating func getOrAddVenue(_ name:String) -> Venue {
        if let venue = venuesByName[name] {
            return venue
        }
        let newVenue = Venue(name:name);
        venuesByName[name] = newVenue;
        return newVenue;
    }
    
    private mutating func addMeal(_ meal:Meal) {
        _ = getOrAddVenue(meal.getVenue().name);
        index(meal)
    }
    
    private mutating func index(_ meal:Meal) {
        let venue = getOrAddVenue(meal.getVenue().name);
        mealsByVenue[venue.id, default: []].append(meal)
        mealsById[meal.id] = meal;
        for course in meal.courses {
            coursedById[course.id] = course;
        }
    }
    
    // MARK: - Component Models
    
    struct Meal : Identifiable {
        var id:String = Id.createId();
        var venue: Venue;
        var menu: PicturesAndNotes?
        var courses: [Course] = [];
        var date:Date = Date();
        var notes:String?
        
        init(venue: Venue) {
            self.venue = venue
        }
        
        init(id:String, venue: Venue, menu: PicturesAndNotes? = nil, courses: [Course], date: Date, notes: String? = nil) {
            self.id = id
            self.venue = venue
            self.menu = menu
            self.courses = courses
            self.date = date
            self.notes = notes
        }
        
        func getVenue() -> Venue {
            return venue;
        }
        
        
    }
    
    struct Venue {
        let id:String = Id.createId();
        let name: String;
        var rating: Int = 0;
        // Someday: lat/long/etc!
        
        init(name: String) {
            self.name = name
        }
        
        init(name: String, rating: Int) {
            self.name = name
            self.rating = rating
        }
    }
    
    struct Course : Hashable, Equatable, Identifiable {
        var id:String = Id.createId();
        let mealId:String;
        var name:String = "";
        var date:Date = Date();
        var food:PicturesAndNotes = PicturesAndNotes();
        var wine:PicturesAndNotes?;
        var pickedImage:Picture?;
        
        init(mealId: String) {
            self.mealId = mealId
        }
        
        init(id:String, mealId: String, name: String, date: Date, food: PicturesAndNotes, wine: PicturesAndNotes? = nil, pickedImage: Picture? = nil) {
            self.id = id
            self.mealId = mealId
            self.name = name
            self.date = date
            self.food = food
            self.wine = wine
            self.pickedImage = pickedImage
        }
        
        static func == (lhs: AppModel.Course, rhs: AppModel.Course) -> Bool {
            return lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
    
    struct PicturesAndNotes {
        var pictures:[Picture] = [];
        var notes:String?;
        
        init() {
        }
        
        init(pictures: [Picture], notes: String? = nil) {
            self.pictures = pictures
            self.notes = notes
        }
    }
    
    // Encapsulate picture management
    struct Picture : Identifiable {
        var id:String = Id.createId()
        
        // For now, string, until I can figure this one out.
        let src:String;
        
        init(src: String) {
            self.src = src
        }
    }
    
    // Encapsulate ID management.
    struct Id {
        // For now, just use UUID.
        static func createId() -> String {
            return UUID().uuidString
        }
    }
}


// For testing only.
extension AppModel {
    // Populate some test data.
    mutating func addTestData(numTestMeals:Int) {
        for index in 0..<numTestMeals {
            addMeal(
                Meal(
                    id: "m\(index)",
                    venue: Venue(name: "McDonalds", rating:4),
                    menu: PicturesAndNotes(
                        pictures: [
                            Picture(src: "gearshape"),
                            Picture(src: "keyboard"),
                        ],
                        notes: "An amazing menu populated by amazing deals!"),
                    courses: [
                        Course(id: "c1",
                               mealId: "m\(index)",
                               name: "Amuse Bouche",
                               date: Date(),
                               food: PicturesAndNotes(
                                pictures: [
                                    Picture(src: "gearshape"),
                                    Picture(src: "keyboard"),
                                    Picture(src: "figure.walk"),
                                ],
                                notes: "A delightful bite-sized explosion of flavors that sets the perfect tone for the culinary journey ahead."),
                               wine:nil,
                               pickedImage: Picture(src: "gearshape")
                              ),
                        Course(id: "c2",
                               mealId: "m\(index)",
                               name: "Lobster",
                               date: Date(),
                               food: PicturesAndNotes(
                                pictures: [
                                    Picture(src: "gearshape"),
                                    Picture(src: "keyboard"),
                                    Picture(src: "figure.walk"),
                                ],
                                notes: "A succulent lobster dish that boasts tender, buttery meat perfectly complemented by a rich, flavorful sauce."),
                               wine:nil,
                               pickedImage: nil
                              ),
                        Course(id: "c3",
                               mealId: "m\(index)",
                               name: "Veal",
                               date: Date(),
                               food: PicturesAndNotes(
                                pictures: [
                                    Picture(src: "gearshape"),
                                    Picture(src: "keyboard"),
                                    Picture(src: "figure.walk"),
                                ],
                                notes: "A tender veal dish with a delicate balance of flavors, offering a melt-in-your-mouth experience."),
                               wine: PicturesAndNotes(
                                pictures: [
                                    Picture(src: "gearshape"),
                                    Picture(src: "keyboard"),
                                ],
                                notes: "A masterful wine pairing that elevates each dish, enhancing flavors and creating a harmonious dining experience."),
                               pickedImage: Picture(src: "gearshape")
                              ),
                        Course(id: "c4",
                               mealId: "m\(index)",
                               name: "Amuse Bouche",
                               date: Date(),
                               food: PicturesAndNotes(
                                pictures: [
                                    Picture(src: "gearshape"),
                                ],
                                notes: "Chocolate for days!"),
                               wine:nil,
                               pickedImage: nil
                              ),
                    ],
                    date: Date(),
                    notes: "A lovely meal with amazingly mature cheese on the Big Mac."
                )
            )
        }
    }
}
