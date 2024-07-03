//
//  AppModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import Foundation


// Backend model for all app state.
struct AppModel {
    // All top-level storage.  Yes, there is duplication here.
    private var mealsById:[String:Meal] = [:];
    private var venuesByName:[String:Venue] = [:];
    private var coursesById:[String:Course] = [:];
               
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
    
    mutating func setRatingFor(_ mealId:String, rating:Int) {
        mealsById[mealId]!.venue.rating = rating;
    }
    func getRatingFor(_ mealId:String) -> Int {
        return mealsById[mealId]!.venue.rating;
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

    
    mutating func removeCourseFrom(_ mealId:String, at:Int) {
        if let _ = getMealFor(mealId) {
            mealsById[mealId]!.courses.remove(at: at)
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
    
    // Default value for empty image.
    static func missingPicture() -> Picture {
        return Picture(src: "fork.knife.circle")
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
        _ = getOrAddVenue(meal.venue.name);
        index(meal)
    }

    private mutating func addMeal(venue:Venue) -> Meal {
        let newMeal = Meal(venue:venue)
        index(newMeal)
        return newMeal
    }
    
    private mutating func index(_ meal:Meal) {
        let _ = getOrAddVenue(meal.venue.name);
        mealsById[meal.id] = meal;
        for course in meal.courses {
            coursesById[course.id] = course;
        }
    }
    

    
    // MARK: - Component Models
    
    struct Meal : Identifiable {
        var id:String = Id.createId();
        var venue: Venue = Venue();
        var menu: PicturesAndNotes = PicturesAndNotes()
        var courses: [Course] = [];
        var date:Date = Date();
        var notes:String = ""
        var pickedImage:Picture = AppModel.missingPicture();

        init() {
        }
        
        init(venue: Venue) {
            self.venue = venue
        }
        
        init(id:String, venue: Venue, menu: PicturesAndNotes, courses: [Course], date: Date, notes:String) {
            self.id = id
            self.venue = venue
            self.menu = menu
            self.courses = courses
            self.date = date
            self.notes = notes
        }
    }
    
    struct Venue {
        let id:String = Id.createId();
        var name: String = ""
        var rating: Int = 0;
        // Someday: lat/long/etc!
 
        init() {
        }
        
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
        var pickedImage:Picture = AppModel.missingPicture();
        
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
        var pictures:[Picture] = [];
        var notes:String = "";
        
        init() {
        }
        
        init(notes:String) {
            self.notes = notes;
        }
        
        init(pictures: [Picture], notes: String) {
            self.pictures = pictures
            self.notes = notes
        }
    }
    
    enum PictureState {
        case empty
        case deleted
        case filled
    }
    
    // Encapsulate picture management
    struct Picture : Identifiable, Hashable {
        var id:String = Id.createId()
        var state:PictureState = .empty
       
        // For now, string, until I can figure this one out.
        var src:String;
        
        init(src: String) {
            self.src = src
            self.state = .filled
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
                               wine: PicturesAndNotes(),
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
                               wine:PicturesAndNotes(),
                               pickedImage: AppModel.missingPicture()
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
                               wine:PicturesAndNotes(),
                               pickedImage: AppModel.missingPicture()
                              ),
                    ],
                    date: Date(),
                    notes: "A lovely meal with amazingly mature cheese on the Big Mac."
                )
            )
        }
    }
}
