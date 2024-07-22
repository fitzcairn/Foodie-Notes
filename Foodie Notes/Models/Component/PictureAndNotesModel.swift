//
//  PictureAndNotesModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/22/24.
//

import Foundation

struct PicturesAndNotes: Codable, Hashable {
    var pictures:[Picture] = [];
    var notes:String = "";

    // Added later to allow for beverage pairings to be shared.
    var sameAsPrevious:Bool?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(notes)
        hasher.combine(pictures)
    }
}
