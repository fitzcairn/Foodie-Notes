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
    var menus: [PicturesAndNotes] = [];
    var courses: [Course] = [];
    var date:Date = Date();
    var notes:String = ""
    var pickedImage:Picture?
    var rating: Int = 0;
    
    // Added this way for backwards compat with existing saved data.
    private var _cuisines: [Cuisine]?
    var cuisines: [Cuisine] {
        get { _cuisines ?? [] }
        set { _cuisines = newValue }
    }
    
    init(venueName:String) {
        venue.name = venueName;
    }
    
    static func == (lhs: Meal, rhs: Meal) -> Bool {
        guard lhs.id == rhs.id else { return false }
        var lhsHash = Hasher()
        lhsHash.combine(lhs)
        var rhsHash = Hasher()
        rhsHash.combine(rhs)
        return lhsHash.finalize() == rhsHash.finalize()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(venue)
        hasher.combine(date)
        hasher.combine(menus)
        hasher.combine(notes)
        hasher.combine(rating)
        hasher.combine(courses)
        hasher.combine(pickedImage)
    }
}

// Encapsulate ID management.
struct Id {
    // For now, just use UUID.
    static func createId() -> String {
        return UUID().uuidString
    }
}

