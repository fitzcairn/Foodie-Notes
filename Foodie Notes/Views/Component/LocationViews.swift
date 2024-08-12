//
//  LocationViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/18/24.
//

import SwiftUI
import MapKit

/*struct LocationIcon: View {
    var edit = false;
    
    var body: some View {
        FoodieIcon("\u{e91e}", Colors.IconSecondary, padding:0)
    }
}

struct LocationView: View {
    let location: Location?
    
    var body: some View {
        // TODO: REMOVE
        let location: Location? = self.location ?? Location(lat: 10, long: 10, city: "Cambridge", country: "United Kingdom")
        HStack {
            if (location?.city != nil && location?.country != nil) {
                LocationIcon()
                
                FoodieText("\(location!.city!), \(location!.country!)", Colors.TextStaticTextSecondary, size:12, weight:.medium)
                Spacer()
            } else {
                EmptyView()
            }
        }
    }
}*/

struct LocationEditView: View {
    @Environment(NetworkService.self) private var networkService
    @StateObject var locViewModel:AsyncLocationViewModel = AsyncLocationViewModel()
    
    @Binding var location: Location?
    @Binding var nearestRestaurant: String
    
    @State var showMap:Bool = false;
    @State private var newLocation: SearchResult?

    var body: some View {
        HStack {
            if (location != nil) {
                // If we have a location already, use it.
                LocationView(location: location!)
            } else if networkService.isConnected {
                AsyncLocationView(
                    source: locViewModel,
                    progressContent: { Loading() },
                    locContent: { LocationView(location: locViewModel.location) },
                    errorContent: { EmptyView() })
                .onChange(of: locViewModel.location) {
                    location = locViewModel.location
                    locViewModel.fetchVenueSuggestionFor(location)
                }
                .onChange(of: locViewModel.nearestRestaurant) {
                    if nearestRestaurant.isEmpty && locViewModel.nearestRestaurant != nil {
                        nearestRestaurant = locViewModel.nearestRestaurant!
                    }
                }
            } else {
                HStack {
                    LocationIcon()
                    FoodieText("( no internet connection )", Colors.TextStaticTextSecondary, size:12, weight:.medium)
                    Spacer()
                }
            }
        }
        .onTapGesture {
            if networkService.isConnected {
                showMap = true;
            }
        }
        .sheet(isPresented: $showMap) {
            SearchableMap(newLocation: $newLocation)
                .onTapGesture {
                    showMap = false;
                    location = newLocation != nil ? newLocation?.toLocation() : location;
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
