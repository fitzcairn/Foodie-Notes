//
//  EditableLocationView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/12/24.
//

import SwiftUI

struct EditableLocationView: View {
    @Environment(NetworkService.self) private var networkService
    @StateObject var locViewModel:AsyncLocationViewModel = AsyncLocationViewModel()

    let title:String;
    @Binding var location: Location?
    @Binding var venueName: String
    let onSave:() -> Void;
    
    init(_ title: String, location: Binding<Location?>, venueName: Binding<String>, onSave: @escaping () -> Void) {
        self.title = title
        self._location = location
        self._venueName = venueName
        self.onSave = onSave
    }
    
    var body : some View {
        EditableLocationComponent(title, $location, onSave) {
            VStack(alignment: .trailing, spacing: 4) {
                HStack {
                    if (location != nil) {
                        // If we have a location already, use it.
                        LocationView(location: location!)
                    } else if networkService.isConnected {
                        AsyncLocationView(
                            source: locViewModel,
                            progressContent: {
                                Loading()
                                    .padding(.leading, 2)
                                    .padding(.trailing, 6)
                                FoodieText("( finding location )", Colors.TextStaticTextSecondary, size:12, weight:.medium)
                            },
                            locContent: {
                                LocationView(location: locViewModel.location)
                            },
                            errorContent: {
                                LocationView(location: nil)
                            })
                        .onChange(of: locViewModel.location) {
                            location = locViewModel.location
                            locViewModel.fetchVenueSuggestionFor(location)
                        }
                        .onChange(of: locViewModel.nearestRestaurant) {
                            if venueName.isEmpty && locViewModel.nearestRestaurant != nil {
                                venueName = locViewModel.nearestRestaurant!
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
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(12)
            .background(Colors.FillStaticFillPrimary)
            .cornerRadius(8)
            .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
            .shadow(color: Colors.ShadowEdge, radius: 4, x: 0, y: 0)
        }
    }
}

struct LocationIcon: View {
    var body: some View {
        FoodieIcon("\u{e91e}", Colors.IconSecondary, padding:0)
    }
}

struct LocationView: View {
    let location: Location?
    
    var body: some View {
        HStack {
            LocationIcon()
            if (location?.city != nil && location?.country != nil) {
                FoodieText("\(location!.city!), \(location!.country!)", Colors.TextStaticTextSecondary, size:12, weight:.medium)
            } else {
                FoodieText("( no location found )", Colors.TextStaticTextSecondary, size:12, weight:.medium)
            }
        }
    }
}

private struct EditableLocationComponent<Content: View>: View {
    @Environment(NetworkService.self) private var networkService
    @StateObject var locViewModel:AsyncLocationViewModel = AsyncLocationViewModel()
    
    let title:String;
    @Binding var location: Location?
    let onSave:() -> Void;
    let content: Content;
    
    @State var showSheet:Bool = false;
    @State private var newLocation: SearchResult?
    
    init(_ title:String, _ location:Binding<Location?>, _ onSave: @escaping () -> Void, @ViewBuilder _ content: () -> Content) {
        self.title = title;
        self._location = location;
        self.onSave = onSave;
        self.content = content()
    }
    
    var body: some View {
        content
            .onTapGesture {
                showSheet.toggle()
            }
            .sheet(isPresented: $showSheet) {
                EditSheetView(
                    topLeftButton: {
                        SmallActionBackButton(icon: "\u{e900}") {
                            showSheet.toggle()
                        }
                    },
                    topRightButton: {
                    },
                    editView: {
                        FoodieText(title, Colors.TextStaticTextSecondary, size:16, weight:.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                        
                        VerticalSpace(8)
                        
                        SearchableMap(newLocation: $newLocation)
                    },
                    saveButton: {
                        LargeActionRedButton(icon:"\u{e905}") {
                            location = newLocation != nil ? newLocation?.toLocation() : location;
                            onSave()
                            showSheet.toggle()
                        }
                    }
                )
            }
    }
}
