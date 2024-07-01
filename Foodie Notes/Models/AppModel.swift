//
//  AppModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import Foundation


// Backend model for all app state.
struct AppModel {

    // All app model storage.
    private var mealsById:[String:Meal] = [:];
    private var venuesByName:[String:Venue] = [:];
    private var coursesById:[String:Course] = [:];
    private var picturesById:[String:Picture] = [:];

    // Default value for empty image.
    private static var missingPicture = Picture(src: "fork.knife.circle")
            
    
    // MARK: - Public Setter Intents
    
    mutating func addMeal(at venueName:String?) -> Meal {
        let venue = getOrAddVenue(venueName);
        let meal = Meal(venue: venue);
        index(meal)
        return meal;
    }
    
    mutating func getOrAddMealFor(_ mealId:String?) -> Meal {
        let venue = getOrAddVenue(nil) // use null venue.
        if let mealId = mealId {
            if let meal = getMealFor(mealId) {
                return meal;
            }
            // Else we have a corrupt mealId.  Recover by discarding.
        }
        return addMeal(venue:venue)
    }
    
    mutating func updateMeal(_ mealId:String, meal:Meal) {
        index(meal)
    }
    
    mutating func addCourseToMeal(mealId:String, course:Course) {
        if let _ = getMealFor(mealId) {
            mealsById[mealId]!.courseIds.append(course.id)
            coursesById[course.id] = course
        }
    }
    
    mutating func addCourseToMeal(mealId: String) -> Course {
        let course = Course(mealId: mealId)
        addCourseToMeal(mealId: mealId, course: course)
        return course
    }

    
    mutating func removeCourseFromMeal(mealId:String, at:Int) {
        if let _ = getMealFor(mealId) {
            mealsById[mealId]!.courseIds.remove(at: at)
        }
    }
    
    mutating func setMenuFor(_ mealId:String, menu:PicturesAndNotes) {
        if let _ = getMealFor(mealId) {
            mealsById[mealId]!.menu = menu
        }
    }
    
    mutating func setNotesFor(_ mealId:String, notes:String) {
        if let _ = getMealFor(mealId) {
            mealsById[mealId]!.notes = notes
        }
    }
    
    
    
    // MARK: - Public Getter Intents
    
    func getCourse(id:String) -> Course? {
        return coursesById[id];
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
   
    func getPictureFor(_ pictureId:String) -> Picture? {
        return picturesById[pictureId];
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
    
    private mutating func addMeal(_ meal:Meal) {
        _ = getOrAddVenue(meal.getVenue().name);
        index(meal)
    }

    private mutating func addMeal(venue:Venue) -> Meal {
        let newMeal = Meal(venue:venue)
        index(newMeal)
        return newMeal
    }
    
    
    // MARK: - Private Members: Index Updaters

    private mutating func index(_ pictures:[Picture]) {
        for picture in pictures {
            picturesById[picture.id] = picture;
        }
    }
   

    
    private mutating func index(_ courses:[Course]) {
        for course in courses {
            coursesById[course.id] = course;
        }
    }
   
    private mutating func index(_ meal:Meal) {
        let venue = getOrAddVenue(meal.getVenue().name);
        mealsById[meal.id] = meal;
    }
    
    // MARK: - Component Models
    
    struct Meal : Identifiable {
        var id:String = Id.createId();
        var venue: Venue;
        var menu: PicturesAndNotes = PicturesAndNotes()
        var courseIds: [String] = [];
        var date:Date = Date();
        var notes:String = ""
        
        init(venue: Venue) {
            self.venue = venue
        }
        
        init(id:String, venue: Venue, menu: PicturesAndNotes, courseIds: [String], date: Date, notes: notes) {
            self.id = id
            self.venue = venue
            self.menu = menu
            self.courseIds = courseIds
            self.date = date
            self.notes = notes
        }
        
        func getVenue() -> Venue {
            return venue;
        }
        
        
    }
    
    struct Venue {
        let id:String = Id.createId();
        var name: String = ""
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
        var wine:PicturesAndNotes = PicturesAndNotes();
        var pickedImage:Picture = AppModel.missingPicture;
        
        init(mealId: String) {
            self.mealId = mealId
        }
        
        init(id:String, mealId: String, name: String, date: Date, food: PicturesAndNotes, wine: PicturesAndNotes, pickedImage: Picture) {
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
        var pictureIds:[String] = [];
        var notes:String = "";
        
        init() {
        }
        
        init(pictureIds: [String], notes: String) {
            self.pictureIds = pictureIds
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
            let mealId = "m\(index)"
            addMeal(
                Meal(
                    id: mealId,
                    venue: Venue(name: "McDonalds", rating:4),
                    menu: PicturesAndNotes(
                        pictures: [
                            Picture(src: "gearshape"),
                            Picture(src: "keyboard"),
                        ],
                        notes: "An amazing menu populated by amazing deals!"),
                    courseIds: []
                    date: Date(),
                    notes: "A lovely meal with amazingly mature cheese on the Big Mac."
                )
            )
            
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
            
            for
            
            addCourseToMeal(mealId: mealId, course: Course)
        }
    }
}
