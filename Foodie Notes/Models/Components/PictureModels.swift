//
//  PictureModels.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/5/24.
//

import Foundation


// Encapsulate picture management
struct Picture : Identifiable, Hashable {
    var id:String = Id.createId()
    var deleted:Bool = false;
    var url:URL? = nil
    
    init() {
    }
    
    init(url:URL) {
        self.url = url
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
    }
}

struct PicturesAndNotes {
    var pictures:[Picture] = [];
    var notes:String = "";
    
    init() {
    }
    
    init(notes:String) {
        self.notes = notes;
    }
    
    init(pictures: [Picture], notes: String) {
        self.pictures = pictures
        self.notes = notes
    }
}

