//
//  VenueModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/5/24.
//

import Foundation

struct Location : Hashable, Codable, Equatable {
    var lat:Double?
    var long:Double?
    var city:String?
    var country:String?
}

struct VenueGuideLink: Codable {
    let guide:VenueGuide;
    var url:URL? // Can be nil if there is no guide link for this guide type.
}

struct Venue : Hashable, Codable, Equatable {
    var id:String = Id.createId()
    var name: String = ""
    var michelin: Michelin = .unselected
    var guideLink:VenueGuideLink?
    var location:Location?
    
    init(_ name: String = "") {
        self.name = name
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
