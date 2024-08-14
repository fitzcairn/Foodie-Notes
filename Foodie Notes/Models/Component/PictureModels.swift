//
//  PictureModels.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/5/24.
//

import Foundation

struct Picture : Identifiable, Hashable, Codable {
    var id:String = Id.createId()
    var deleted:Bool = false;
    var photo:Photo?
    
    init(photo:Photo) {
        self.photo = photo;
    }

    static func == (lhs: Picture, rhs: Picture) -> Bool {
        return (
            lhs.id == rhs.id &&
            lhs.deleted == rhs.deleted &&
            lhs.photo == rhs.photo
        )
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(deleted)
        hasher.combine(photo)
    }
}
