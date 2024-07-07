//
//  VenueModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/5/24.
//

import Foundation


struct Venue : Hashable, Codable {
    let id:String;
    var name: String = ""
    // Someday: lat/long/etc!

    init() {
        id = Id.createId();
    }
    
    init(name: String) {
        self.name = name
        id = Id.createId();
    }
}
