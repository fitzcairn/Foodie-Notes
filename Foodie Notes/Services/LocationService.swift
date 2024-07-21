//
//  LocationService.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/18/24.
//  Almost entirely cribbed from: https://medium.com/@mourad.kirat.9/swiftui-core-location-256834b608b3
//

import Foundation
import CoreLocation


// TODO: convert to a real singleton service.
class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
            // Insert code here of what should happen when Location services are authorized
            authorizationStatus = .authorizedWhenInUse
            locationManager.requestLocation()
            break
            
        case .restricted:  // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            authorizationStatus = .restricted
            break
            
        case .denied:  // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            authorizationStatus = .denied
            break
            
        case .notDetermined:        // Authorization not determined yet.
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Needed as a delegate, but no update needed in this app.
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Debug only; can be transparent to the user.
        print("error: \(error.localizedDescription)")
    }
    func stopLocation() {
        locationManager.stopUpdatingLocation()
    }
}
