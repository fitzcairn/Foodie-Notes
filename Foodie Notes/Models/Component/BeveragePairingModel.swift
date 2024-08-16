//
//  BeveragePairingModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/13/24.
//

import Foundation

struct BeverageLookupInfo: Codable, Hashable, Equatable {
    var name:String = ""
    var url:URL?
    var imgIdRecognized: String? // Don't try again unless there's another image.
}

struct BeveragePairing: Hashable, Equatable, Identifiable, Codable {
    var id:String = Id.createId();
    var picture:Picture?
    var notes:String = ""
    var info:BeverageLookupInfo = BeverageLookupInfo()
    var sameAsPrevious:Bool = false

    static func == (lhs: BeveragePairing, rhs: BeveragePairing) -> Bool {
        guard lhs.id == rhs.id else { return false }
        var lhsHash = Hasher()
        lhsHash.combine(lhs)
        var rhsHash = Hasher()
        rhsHash.combine(rhs)
        return lhsHash.finalize() == rhsHash.finalize()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(picture)
        hasher.combine(notes)
        hasher.combine(info)
        hasher.combine(sameAsPrevious)
    }
}
