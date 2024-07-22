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
    var url:URL? = nil // Kept for future compatibility with web images.

    // Image
    var photo:Photo?

    // TODO: Converter to eliminate
    @available(*, deprecated, message: "Don't use")
    var data:Data? = nil;

    
    init(photo:Photo) {
        self.photo = photo;
    }

    // TODO: Converter to eliminate
    @available(*, deprecated, message: "Don't use")
    init() {
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
        hasher.combine(photo)
    }
}
