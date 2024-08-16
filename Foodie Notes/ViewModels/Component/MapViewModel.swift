//
//  MapViewModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/23/24.
//

import Foundation
import MapKit

struct SearchResult: Identifiable, Hashable {
    let id = UUID()
    let location: CLLocationCoordinate2D
    let city: String
    let country: String
    let address: String
    let name: String

    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        lhs.id == rhs.id
    }

    func toLocation() -> Location {
        return Location(
            lat: self.location.latitude,
            long: self.location.longitude,
            city: self.city,
            country: self.country)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class MapViewModel: NSObject, MKLocalSearchCompleterDelegate, ObservableObject {
    func search(with query: String, coordinate: CLLocationCoordinate2D? = nil) async throws -> [SearchResult] {
        let mapKitRequest = MKLocalSearch.Request()
        mapKitRequest.naturalLanguageQuery = query
        mapKitRequest.resultTypes = .pointOfInterest
        if let coordinate {
            mapKitRequest.region = .init(.init(origin: .init(coordinate), size: .init(width: 1, height: 1)))
        }
        let search = MKLocalSearch(request: mapKitRequest)

        let response = try await search.start()

        return response.mapItems.compactMap { mapItem in
            guard let location = mapItem.placemark.location?.coordinate else { return nil }
            guard let city = mapItem.placemark.locality else { return nil }
            guard let country = mapItem.placemark.country else { return nil }
            guard let address = mapItem.placemark.title else { return nil }
            guard let name = mapItem.placemark.name else { return nil }
           
            return .init(location: location, city: city, country: country, address:address, name:name)
        }
    }
}
