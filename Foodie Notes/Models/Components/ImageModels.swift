//
//  ImageModels.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/21/24.
//

import Foundation

typealias ImageId = String

struct SavedImage : Hashable, Codable, Identifiable {
    var id: ImageId = Id.createId()
    let file:URL
    
    init(id: ImageId, file: URL) {
        self.id = id
        self.file = file
    }
}

struct LoadedImage : Hashable, Codable, Identifiable {
    var id:ImageId = Id.createId()
    let imgData:Data;
}
