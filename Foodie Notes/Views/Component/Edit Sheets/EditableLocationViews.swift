//
//  EditableLocationViews.swift
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
    var showLinkIcon: Bool = false;
    let onSave:() -> Void
    
    var body : some View {
        EditableLocationSheetLayout(title:title, location:$location, name:$venueName, onSave:onSave) {
            VStack(alignment: .trailing, spacing: 4) {
                HStack {
                    if (location != nil) {
                        // If we have a location already, use it.
                        LocationView(location: location!, showLinkIcon: showLinkIcon)
                    } else if networkService.isConnected {
                        AsyncLocationView(
                            source: locViewModel,
                            progressContent: {
                                Loading()
                                    .padding(.leading, 2)
                                    .padding(.trailing, 6)
                                FoodieText("Finding location...", Colors.TextStaticTextSecondary, size:12, weight:.medium)
                            },
                            locContent: {
                                LocationView(location: locViewModel.location, showLinkIcon: showLinkIcon)
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
                            FoodieText("No internet connection.", Colors.TextStaticTextSecondary, size:12, weight:.medium)
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
    var showLinkIcon: Bool = false;
    
    func createLink(_ lat:Double, _ long:Double) -> URL {
        return URL(string: "maps://?q=\(lat),\(long)")!
    }
    
    var body: some View {
        HStack {
            LocationIcon()
            if (location?.city != nil && location?.country != nil) {

                FoodieText("\(location!.city!), \(location!.country!)", Colors.TextStaticTextSecondary, size:12, weight:.medium)

                if showLinkIcon, let lat = location?.lat, let long = location?.long {
                    Spacer()
                    Link("\u{e911}", destination:createLink(lat, long)) // unwrap handled below
                        .font(Font.custom("foodie-icons", size: 24))
                        .foregroundColor(Colors.TextActionTextAction)
                        .buttonStyle(.borderless)
                        .padding(0)
                }
            } else {
                FoodieText("No location found.", Colors.TextStaticTextSecondary, size:12, weight:.medium)
            }
        }
    }
}

private struct EditableLocationSheetLayout<Content: View>: View {
    @Environment(NetworkService.self) private var networkService
    @StateObject var locViewModel:AsyncLocationViewModel = AsyncLocationViewModel()
    
    let title:String;
    @Binding var location: Location?
    @Binding var name:String;
    let onSave:() -> Void
    
    @State var showSheet:Bool = false;
    @State private var newLocation: SearchResult?

    @ViewBuilder let content: Content;

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
                    showDivider: false,
                    mainView: {
                        FoodieText(title, Colors.TextStaticTextSecondary, size:16, weight:.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                        
                        VerticalSpace(8)
                        
                        LocationEditSheet(newLocation: $newLocation, name:$name)
                    },
                    bottomButtons: {
                        EditSheetComponentBottomSingleButton() {
                            EditSheetComponentSaveButton(
                                disabledClosure: { newLocation == nil },
                                action: {
                                    location = newLocation != nil ? newLocation?.toLocation() : location;
                                    onSave()
                                    showSheet.toggle()
                                }
                            )
                        }
                    }
                )
            }
    }
}
