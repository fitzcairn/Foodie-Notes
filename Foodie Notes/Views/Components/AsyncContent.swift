//
//  AsyncContent.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/20/24.
//

import SwiftUI

struct AyncGuideLink<Source:SearchableConfig, ProgressContent: View, LinkContent:View>: View {
    @ObservedObject var source:Source
    let venue:Venue;
    let guide:VenueGuide;
    let progressContent: ProgressContent;
    let linkContent: LinkContent;

    init(source: Source, venue:Venue, guide:VenueGuide = .michelin,@ViewBuilder progressContent: () -> ProgressContent, @ViewBuilder linkContent: () -> LinkContent) {
        self.source = source
        self.guide = guide;
        self.venue = venue
        self.progressContent = progressContent()
        self.linkContent = linkContent()
    }
    
    var body: some View {
        switch source.status {
        case .searching:
            progressContent
                .onAppear {
                    // TODO: undo test search.
                    source.searchFor(name: "Midsummer House", guide: guide, city: "Cambridge", country: "UK")
                    //source.searchFor(name: venue.name, guide: guide, city: venue.city, country: venue.country)
                }
        case .complete:
            linkContent
        case .error, .none:
            EmptyView()
        }
    }
    
}
