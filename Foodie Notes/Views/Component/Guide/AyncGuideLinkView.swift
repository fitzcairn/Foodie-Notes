//
//  AsyncContent.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/20/24.
//

import SwiftUI

struct AyncGuideLinkView<Source:AsyncSearchConfig, ProgressContent: View, LinkContent:View>: View {
    @ObservedObject var source:Source
    let venue:Venue;
    let guide:VenueGuide;
    @ViewBuilder let progressContent: ProgressContent;
    @ViewBuilder let linkContent: LinkContent;
    
    var body: some View {
        switch source.status {
        case .loading:
            progressContent
                .onAppear {
                    source.searchFor(name: venue.name, guide: guide, city: venue.location?.city, country: venue.location?.country)
                }
                .padding(.top, 2)
                .padding(.bottom, 2)
        case .complete:
            linkContent
        case .error, .none:
            FoodieText("No guide link found.", Colors.TextStaticTextSecondary, size:12, weight:.medium)
                .padding(.vertical, 4)
        }
    }
}
