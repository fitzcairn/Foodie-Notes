//
//  MapViewModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/23/24.
//  Heavily influenced by: https://www.polpiella.dev/mapkit-and-swiftui-searchable-map
//

import Foundation
import MapKit

struct SearchCompletions: Identifiable {
    let id = UUID()
    let title: String
    let subTitle: String
    var url: URL?
}

struct SearchResult: Identifiable, Hashable {
    let id = UUID()
    let location: CLLocationCoordinate2D
    let city: String
    let country: String

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
    private let completer: MKLocalSearchCompleter

    var completions = [SearchCompletions]()

    init(completer: MKLocalSearchCompleter) {
        self.completer = completer
        super.init()
        self.completer.delegate = self
    }

    func update(queryFragment: String) {
        completer.resultTypes = .pointOfInterest
        completer.queryFragment = queryFragment
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completions = completer.results.map { completion in
            // Get the private _mapItem property
            let mapItem = completion.value(forKey: "_mapItem") as? MKMapItem

            return .init(
                title: completion.title,
                subTitle: completion.subtitle,
                url: mapItem?.url
            )
        }
    }
    
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

            return .init(location: location, city: city, country: country)
        }
    }
}
