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

    func hash(into hasher: inout Hasher) {
        hasher.combine(notes)
        hasher.combine(pictures)
    }
    
    static func == (lhs: PicturesAndNotes, rhs: PicturesAndNotes) -> Bool {
        return lhs.notes == rhs.notes && lhs.pictures == rhs.pictures
    }
}
