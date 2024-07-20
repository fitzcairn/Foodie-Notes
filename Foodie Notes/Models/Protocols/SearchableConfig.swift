//
//  SearchableConfig.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/20/24.
//

import Foundation

enum Status {
    case searching
    case error
    case complete
    case none
}

protocol SearchableConfig: ObservableObject {
    var status: Status { get }
    
    func searchFor(name:String, guide:VenueGuide?, city:String?, country:String?)
}
