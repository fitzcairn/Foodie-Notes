//
//  AsyncLocationViewModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/22/24.
//

import Foundation
import CoreLocation
import MapKit


class AsyncLocationViewModel: NSObject, AsyncLocationConfig, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()

    @Published var locStatus: Status = .loading
    @Published var searchStatus: Status = .loading

    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var location = Location()
    @Published var nearestRestaurant:String?

    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    // MARK: - Location Manager
    // Publish changes in authorization.
    // TODO: Add UI for when this changes.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
            authorizationStatus = .authorizedWhenInUse
            locationManager.requestLocation()
            break
            
        case .restricted:  // Location services currently unavailable.
            authorizationStatus = .restricted
            break
            
        case .denied:  // Location services currently unavailable.
            authorizationStatus = .denied
            break
            
        case .notDetermined:        // Authorization not determined yet.
            manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Needed as a delegate, but no update needed for my app at the moment.
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Debug only; can be transparent to the user.
        print("error: \(error.localizedDescription)")
    }

    func stopLocation() {
        locationManager.stopUpdatingLocation()
    }

    
    // MARK: - Location API
    func fetchLocation()  {
        guard (self.locStatus != .complete) else { return }
        var loc = Location()
        (loc.lat, loc.long) = getLatLong();
        
        if let lat = loc.lat, let long = loc.long {
            getCityAndCountryLocation(lat, long) { city, country in
                if let city = city, let country = country {
                    loc.city = city
                    loc.country = country
                    
                    // Publish results
                    self.locStatus = (loc.city == nil || loc.country == nil) ? .error : .complete
                    self.location = loc
                } else {
                    self.locStatus = .none
                }
            }
        } else {
            self.locStatus = .error
        }
    }
    
    func fetchVenueSuggestionFor(_ location:Location?) {
        fetchLocation()
        let latitude:Double?  = location?.lat  ?? self.location.lat
        let longitude:Double? = location?.long ?? self.location.long
        guard(latitude != nil && longitude != nil) else { return }
        findNearestRestaurantFor(latitude: latitude!, longitude: longitude!)
        searchStatus = self.nearestRestaurant == nil ? .error : .complete
    }
    
    
    // MARK: - Private Helpers
    // Execute a MapKit search
    private func findNearestRestaurantFor(latitude: Double, longitude: Double, radiusMeters:Double = 20) {
        let request = MKLocalPointsOfInterestRequest(
            center: CLLocationCoordinate2D(latitude:latitude, longitude:longitude),
            radius: radiusMeters)
        request.pointOfInterestFilter = MKPointOfInterestFilter(including: [.restaurant])
        
        MKLocalSearch(request: request).start { response, error in
            guard let response = response else {
                // No restaurant found, nothing else to do.
                return
            }
            
            if (!response.mapItems.isEmpty) {
                if let name = response.mapItems.first?.name {
                    self.nearestRestaurant = name
                }
            }
        }
    }
    
    // Retrieve lat/long.
    private func getLatLong() -> (Double?, Double?) {
        let yourLatitudeString = String(locationManager.location?.coordinate.latitude.description ?? "Error loading")
        let yourLongitudeString = String(locationManager.location?.coordinate.longitude.description ?? "Error loading")
        let latitude = Double(yourLatitudeString)
        let longitude =  Double(yourLongitudeString)
        return (latitude, longitude)
    }
    
    // Location reverse geocode with callback.
    private func getCityAndCountryLocation(_ latitude: Double, _ longitude: Double, completion: @escaping (String?, String?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemarks, _ in
            if let placemark = placemarks?.first {
                let cityName = placemark.locality
                let countryName = placemark.country
                completion(cityName, countryName)
            }
        }
    }
}
