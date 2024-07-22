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
