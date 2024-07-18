//
//  LocationService.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/18/24.
//  Almost entirely cribbed from: https://medium.com/@mourad.kirat.9/swiftui-core-location-256834b608b3
//

import Foundation
import CoreLocation

class LocationInfo {
    private var cityName = ""
    private var countryName = ""
    
    func getCityAndCountryLocation(latitude: Double, longitude: Double, completion: @escaping (String?, String?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemarks, _ in
            guard let placemark = placemarks?.first else { completion(nil, nil); return }
            self.cityName = placemark.locality ?? ""
            self.countryName = placemark.country ?? ""
            completion(self.cityName, self.countryName)
        }
    }
    
    func getNameCity() -> String { cityName }
    
    func getNameCountry() -> String { countryName }
}
