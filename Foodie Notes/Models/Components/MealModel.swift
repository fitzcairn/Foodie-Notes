//
//  MealModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/5/24.
//

import Foundation

struct Meal : Identifiable, Hashable, Codable {
    var id:String = Id.createId();
    var venue: Venue = Venue();
    var menu: PicturesAndNotes = PicturesAndNotes()
    var courses: [Course] = [];
    var date:Date = Date();
    var notes:String = ""
    var pickedImage:Picture?
    var rating: Int = 0;
    
    init() {
    }
    
    init(venue: Venue) {
        self.venue = venue
    }
    
    init(id:String, venue: Venue, menu: PicturesAndNotes, courses: [Course], date: Date, notes:String, rating:Int) {
        self.id = id
        self.venue = venue
        self.menu = menu
        self.courses = courses
        self.date = date
        self.notes = notes
        self.rating = rating
    }
    
    static func == (lhs: Meal, rhs: Meal) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(venue)
        hasher.combine(date)
    }
}

// Encapsulate ID management.
struct Id {
    // For now, just use UUID.
    static func createId() -> String {
        return UUID().uuidString
    }
}

