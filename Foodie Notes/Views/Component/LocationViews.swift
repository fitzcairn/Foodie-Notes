//
//  LocationViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/18/24.
//

import SwiftUI
import MapKit


struct LocationIcon: View {
    var body: some View {
        Image(systemName: "mappin.and.ellipse")
            .resizable()
            .scaledToFit()
            .frame(height: 18)
            .foregroundColor(Color.gray)
            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
    }
}

struct LocationView: View {
    let location: Location?
    
    var body: some View {
        HStack {
            if (location?.city != nil && location?.country != nil) {
                LocationIcon()
                Text("\(location!.city!), \(location!.country!)")
                    .font(.system(size:14, weight: .regular))
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(1)
                Spacer()
            } else {
                EmptyView()
            }
        }
    }
}

struct LocationEditView: View {
    @EnvironmentObject private var locationService:LocationService;
    @StateObject var locViewModel:AsyncLocationViewModel = AsyncLocationViewModel()
    
    @Binding var location: Location?
    @Binding var nearestRestaurant: String
    
    var body: some View {
        if (location != nil) {
            // If we have a location already, use it.
            LocationView(location: location!)
        } else {
            AsyncLocationView(
                source: locViewModel,
                progressContent: { Loading() },
                
                
                // TODO: Why is the binding not getting the location on assignment?
                
                
                locContent: { LocationView(location: locViewModel.location) })
            .onChange(of: locViewModel.location) {
                location = locViewModel.location
                locViewModel.fetchVenueSuggestionFor(location)
            }
            .onChange(of: locViewModel.nearestRestaurant) {
                if nearestRestaurant.isEmpty && locViewModel.nearestRestaurant != nil {
                    nearestRestaurant = locViewModel.nearestRestaurant!
                }
            }
        }
    }
    
    private struct Loading: View {
        var body: some View {
            HStack {
                LocationIcon()
                ProgressView()
                    .frame(height: 18)
                Spacer()
            }
        }
    }
}


        
// TODO: All interaction with services needs to move into a viewmodel.
/*struct LocationEditView: View {
    @EnvironmentObject private var locationService:LocationService;
    
    @Binding var venue: Venue
    @Binding var nearestRestaurant: String
    
    var body: some View {
        LocationView(venue: venue)
            .padding(.leading, 10)
            .onAppear() {
                // If we have a name for this venue already OR a lat, then its been saved previously and
                // we should not muck with it's location data.
                guard(venue.name.isEmpty && venue.latitude == nil) else { return }
                
                let yourLatitudeString = String(locationService.locationManager.location?.coordinate.latitude.description ?? "Error loading")
                let yourLongitudeString = String(locationService.locationManager.location?.coordinate.longitude.description ?? "Error loading")
                venue.latitude = Double(yourLatitudeString)
                venue.longitude =  Double(yourLongitudeString)
                
                // Translate into city and country IF we've not done this yet.
                guard(venue.city == nil) else { return }
                LocationInfo().getCityAndCountryLocation(latitude: venue.latitude ?? 0, longitude: venue.longitude ?? 0) { city, country in
                    if let city = city, let country = country {
                        venue.city = city
                        venue.country = country
                    } else {
                        // Debug only, transparently fail geo lookup.
                        print("Unable to fetch location information.")
                    }
                }
                
                // If we don't have a venue name, attempt to autofill from location.
                guard(venue.latitude != nil && venue.longitude != nil) else { return }
                search(latitude: venue.latitude!, longitude: venue.longitude!)
            }
    }
    
    private func search(latitude: Double, longitude: Double) {
        let request = MKLocalPointsOfInterestRequest(
            center: CLLocationCoordinate2D(latitude:latitude, longitude:longitude),
            radius: 20) // 20 meters
        request.pointOfInterestFilter = MKPointOfInterestFilter(including: [.restaurant])
        
        MKLocalSearch(request: request).start { response, error in
            guard let response = response else {
                // No restaurant found, nothing else to do.
                return
            }
            
            if (!response.mapItems.isEmpty) {
                if let name = response.mapItems.first?.name {
                    nearestRestaurant = name
                }
            }
        }
    }
}*/
