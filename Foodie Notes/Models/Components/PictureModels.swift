//
//  PictureModels.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/5/24.
//

import Foundation


// Encapsulate picture management
struct Picture : Identifiable, Hashable, Codable {
    var id:String = Id.createId()
    var deleted:Bool = false;
    var url:URL? = nil // Kept for future compatibility with web images.
    var data:Data? = nil;
    var thumbnail:Data? = nil;
    
    init() {
    }
    
    init(data:Data?, thumbnail:Data?) {
        self.data = data
        self.thumbnail = thumbnail
    }
    
    static func == (lhs: Picture, rhs: Picture) -> Bool {
        return (
            lhs.id == rhs.id &&
            lhs.deleted == rhs.deleted &&
            lhs.url == rhs.url
        )
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(url)
        hasher.combine(deleted)
        hasher.combine(data)
    }
}

struct PicturesAndNotes: Codable, Hashable {
    var pictures:[Picture] = [];
    var notes:String = "";

    // Added later to allow for beverage pairings to be shared.
    var sameAsPrevious:Bool?
    
    init() {
    }
    
    init(notes:String) {
        self.notes = notes;
    }
    
    init(pictures: [Picture], notes: String) {
        self.pictures = pictures
        self.notes = notes
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(notes)
        hasher.combine(pictures)
    }
}

