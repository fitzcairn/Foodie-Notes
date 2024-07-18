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
    var michelin: Michelin?
    
    // Location
    var latitude: Double?
    var longitude: Double?
    
    // Geo info
    var city:String?
    var country:String?

    init() {
        id = Id.createId();
    }
    
    init(name: String) {
        self.name = name
        id = Id.createId();
    }
}
