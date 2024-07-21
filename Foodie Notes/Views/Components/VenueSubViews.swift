//
//  VenueSubViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/18/24.
//

import SwiftUI
import MapKit

struct VenueSubViews {
    
    private struct LinkImg: View {
        var body: some View {
            Image(systemName: "link")
                .resizable()
                .scaledToFit()
                .frame(height: 18)
                .foregroundColor(Color.gray)
                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
        }
    }
    
    private struct GuideLink: View {
        let guideName:String
        let url:URL?
        
        var body: some View {
            HStack {
                if let url = url {
                    LinkImg()
                    Link(guideName, destination:url)
                        .font(.system(size:14, weight: .regular))
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(1)
                    Spacer()
                }
                else {
                    EmptyView()
                }
            }
        }
    }
    
    private struct Searching: View {
        var body: some View {
            HStack {
                LinkImg()
                ProgressView()
                    .frame(width: 18, height: 18)
                Spacer()
            }
        }
    }
    
    
    struct GuideLinkView: View {
        @EnvironmentObject var viewModel:AppViewModel;
        @StateObject var linkViewModel:AsyncLinkViewModel = AsyncLinkViewModel()

        let meal: Meal;
        // Eventually, allow for other guides.
        let guide:VenueGuide = .michelin
        
        var body: some View {
            // If we have a link already, use it.
            if let guideLink = meal.venue.guideLink {
                GuideLink(guideName:guideLink.guide.displayName, url:guideLink.url)
            } else {
                // Load link async, and update view.
                AyncGuideLinkView(
                    source:linkViewModel,
                    venue:meal.venue,
                    guide:guide,
                    progressContent: { Searching() },
                    // Can safely unwrap link due to switch statement in AyncGuideLink
                    linkContent: { GuideLink(guideName:guide.displayName, url:linkViewModel.link) }
                )
                .onChange(of: linkViewModel.link) {
                    var newMeal = meal
                    if let url = linkViewModel.link {
                        newMeal.venue.guideLink = VenueGuideLink(guide: .michelin, url: url)
                    } else {
                        // Not found, don't look again for this guide type.
                        newMeal.venue.guideLink = VenueGuideLink(guide: .michelin, url: nil)
                    }
                    viewModel.saveEditedMealFor(newMeal)
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
        
    // TODO: All interaction with services needs to move into a viewmodel.
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
    }
}
