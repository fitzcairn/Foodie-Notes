//
//  VenueModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/5/24.
//

import Foundation


struct VenueGuideLink: Codable {
    let guide:VenueGuide;
    var url:URL? // Can be nil if there is no guide link for this guide type.
}

struct Venue : Hashable, Codable, Equatable {
    let id:String;
    var name: String = ""
    
    // Michelin rating
    var michelin: Michelin?
    
    // Location
    var latitude: Double?
    var longitude: Double?
    
    // Geo info
    var city:String?
    var country:String?
    
    // Reference guide link, if there is one.
    var guideLink:VenueGuideLink?

    init() {
        id = Id.createId();
    }
    
    init(name: String) {
        self.name = name
        id = Id.createId();
    }
    
    init(name: String, city: String, country: String) {
        self.name = name
        self.city = city
        self.country = country
        id = Id.createId();
    }
    
    static func == (lhs: Venue, rhs: Venue) -> Bool {
        guard lhs.id == rhs.id else { return false }
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
}
