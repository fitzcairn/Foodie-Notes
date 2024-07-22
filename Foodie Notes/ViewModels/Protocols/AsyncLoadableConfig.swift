//
//  AsyncLoadableConfig.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/20/24.
//

import Foundation

enum Status {
    case loading
    case error
    case complete
    case none
}

protocol AsyncSearchConfig: ObservableObject {
    var status: Status { get }

    // Guide lookup
    func searchFor(name:String, guide:VenueGuide?, city:String?, country:String?)
}

@MainActor
protocol AsyncImageConfig: ObservableObject {
    var status: Status { get }

    // Load an image
    func loadImageFor(_ img:SavedImage)
}
