//
//  PictureAndNotesModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/22/24.
//

import Foundation

struct InfoLink: Codable, Equatable {
    var name:String?
    var url:URL?
}

struct PicturesAndNotes: Codable, Hashable {
    var pictures:[Picture] = [];
    var notes:String = "";

    // Added Jul 20 to allow for beverage pairings to be shared.
    var sameAsPrevious:Bool?
    
    // New as of Jul 29 for wine pairing links.
    var infoLink:InfoLink?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(notes)
        hasher.combine(pictures)
    }
    
    static func == (lhs: PicturesAndNotes, rhs: PicturesAndNotes) -> Bool {
        return lhs.notes == rhs.notes && lhs.pictures == rhs.pictures && lhs.sameAsPrevious == rhs.sameAsPrevious && lhs.infoLink == rhs.infoLink
    }
}
