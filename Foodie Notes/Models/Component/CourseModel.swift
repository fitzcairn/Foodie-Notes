//
//  CourseModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/5/24.
//

import Foundation

struct Course : Hashable, Equatable, Identifiable, Codable {
    var id:String = Id.createId();
    let mealId:String;
    var name:String = "";
    var date:Date = Date();
    var food:PicturesAndNotes = PicturesAndNotes();
    var beveragePairings:[BeveragePairing] = []
    var pickedImage:Picture?
    var rating: Int = 0;
   
    init(mealId: String, name: String) {
        self.mealId = mealId
        self.name = name
    }

    static func == (lhs: Course, rhs: Course) -> Bool {
        guard lhs.id == rhs.id else { return false }
        var lhsHash = Hasher()
        lhsHash.combine(lhs)
        var rhsHash = Hasher()
        rhsHash.combine(rhs)
        return lhsHash.finalize() == rhsHash.finalize()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(mealId)
        hasher.combine(name)
        hasher.combine(date)
        hasher.combine(food)
        hasher.combine(beveragePairings)
        hasher.combine(pickedImage)
        hasher.combine(rating)
    }
}
