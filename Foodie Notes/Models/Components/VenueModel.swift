//
//  VenueModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/5/24.
//

import Foundation


struct Venue : Codable {
    let id:String;
    var name: String = ""
    var rating: Int = 0;
    // Someday: lat/long/etc!

    init() {
        id = Id.createId();
    }
    
    init(name: String) {
        self.name = name
        id = Id.createId();
    }
    
    init(name: String, rating: Int) {
        self.name = name
        self.rating = rating
        id = Id.createId();
    }
}
