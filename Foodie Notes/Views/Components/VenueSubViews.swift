//
//  VenueSubViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/18/24.
//

import SwiftUI
import MapKit


// TODO: All interaction with services needs to move into the viewmodel.
struct VenueSubViews {
    
    struct GuideLink: View {
        let venue:Venue;
        
        var body: some View {
            HStack {
                Image(systemName: "link")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 18)
                    .foregroundColor(Color.gray)
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                textOrLink
                    .font(.system(size:14, weight: .regular))
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(1)
                Spacer()
            }
        }
        
        @ViewBuilder
        var textOrLink: some View {
            if let guideLink = venue.guideLink {
                Link(guideLink.guide.displayName, destination: guideLink.url)
            } else {
                Text("Searching...")
            }
        }
    }
    
    
    struct GuideLinkEditView: View {
        @EnvironmentObject var viewModel:AppViewModel;
        @EnvironmentObject var webService:WebFetchService;

        @Binding var venue: Venue;
        
        var body: some View {
            VenueSubViews.GuideLink(venue: venue)
            .onAppear() {
                if (venue.guideLink == nil) {
                    //webService.fetchMichelinGuideLinkFor(name: venue.name, city: venue.city, country: venue.country)
                    webService.fetchMichelinGuideLinkFor(name: "Midsummer House", city: "Cambridge", country: "United Kingdom")
                }
            }
            .onChange(of: webService.link) {
                if let url = webService.link {
                    let guideLink = VenueGuideLink(guide: .michelin, url: url)
                    venue.guideLink = guideLink
                    viewModel.triggerRefresh()
                }
            }
        }
        
    }
    
    
    struct LocationView: View {
        let venue: Venue
        
        var body: some View {
            HStack {
                if (venue.city != nil && venue.country != nil) {
                    Image(systemName: "mappin.and.ellipse")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 18)
                        .foregroundColor(Color.gray)
                        .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    Text("\(venue.city!), \(venue.country!)")
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
                radius: 5)
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
    }
}
