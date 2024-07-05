//
//  VenueModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/5/24.
//

import Foundation


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
