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
    
    func searchFor(name:String, guide:VenueGuide?, city:String?, country:String?)
}

@MainActor
protocol AsyncImageConfig: ObservableObject {
    var status: Status { get }

    func loadImageFor(_ img:SavedImage)
}

protocol AsyncLocationConfig: ObservableObject {
    var locStatus: Status { get }
    var searchStatus: Status { get }

    func fetchLocation()
    func fetchVenueSuggestionFor(_ location:Location?)
}

protocol AsyncLabelRecognitionConfig: ObservableObject {
    var status: Status { get }

    func recognizeWineFor(_ img:SavedImage)
}
