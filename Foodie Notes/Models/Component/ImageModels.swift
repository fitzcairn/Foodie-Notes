//
//  ImageModels.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/21/24.
//

import Foundation

typealias ImageId = String

struct SavedImage : Hashable, Codable, Identifiable {
    var id: ImageId = Id.createId() // Also the file name.
}

struct LoadedImage : Hashable, Codable, Identifiable {
    var id:ImageId = Id.createId()
    let imgData:Data;
}

struct Photo : Identifiable, Hashable, Codable {
    var id:String = Id.createId()

    let full:SavedImage
    let thumb:SavedImage
}
