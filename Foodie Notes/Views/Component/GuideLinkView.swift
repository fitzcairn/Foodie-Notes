//
//  GuideLinkView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/22/24.
//

import SwiftUI


struct GuideLinkView: View {
    @EnvironmentObject var viewModel:AppViewModel;
    @Environment(NetworkService.self) private var networkService
    @StateObject var linkViewModel:AsyncLinkViewModel = AsyncLinkViewModel()

    let meal: Meal;
    // Eventually, allow for other guides.
    let guide:VenueGuide = .michelin
    
    var body: some View {
        // If we have a link already, use it.
        if let guideLink = meal.venue.guideLink {
            GuideLink(guideName:guideLink.guide.displayName, url:guideLink.url)
        } else if networkService.isConnected {
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
        } else {
            GuideLink(guideName: "No Internet Connection", url: URL(string: ""))
        }
    }

    private struct GuideLink: View {
        let guideName:String
        let url:URL?
        
        var body: some View {
            HStack {
                if let url = url {
                    Link(guideName, destination:url)
                        .font(
                          Font.custom("Nunito", size: 12)
                            .weight(.semibold)
                        )
                        .foregroundColor(Colors.TextActionTextAction)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                }
                else {
                    EmptyView()
                }
            }
        }
    }
}
