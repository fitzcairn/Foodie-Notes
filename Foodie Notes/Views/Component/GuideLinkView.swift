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

    @Binding var venue: Venue;
    var onSave:() -> Void = {}
    var iconOnRight:Bool = false;
    
    // Eventually, allow for other guides.
    let guide:VenueGuide = .michelin
    
    var body: some View {
        // If we have a link already, use it.
        if let guideLink = venue.guideLink {
            GuideLink(guideName:guideLink.guide.displayName, url:guideLink.url, iconOnRight:iconOnRight)
        } else if networkService.isConnected {
            // Load link async, and update view.
            AyncGuideLinkView(
                source:linkViewModel,
                venue:venue,
                guide:guide,
                progressContent: { Searching() },
                // Can safely unwrap link due to switch statement in AyncGuideLink
                linkContent: { GuideLink(guideName:guide.displayName, url:linkViewModel.link, iconOnRight:iconOnRight) }
            )
            .onChange(of: linkViewModel.link) {
                if let url = linkViewModel.link {
                    venue.guideLink = VenueGuideLink(guide: .michelin, url: url)
                    onSave()
                }
            }
        } else {
            FoodieText("( not connected )", Colors.TextStaticTextSecondary, size:12, weight:.medium)
        }
    }

    private struct GuideLink: View {
        let guideName:String
        let url:URL?
        var iconOnRight:Bool = false;
        
        var icon: some View {
                FoodieIcon("\u{e911}", Colors.TextActionTextAction, padding:0)
        }
        
        var link: some View {
            Link(guideName, destination:url!) // unwrap handled below
                .font(
                    Font.custom("Nunito", size: 12)
                        .weight(.semibold)
                )
                .foregroundColor(Colors.TextActionTextAction)
                .buttonStyle(.borderless)
                .lineLimit(1)
                .fixedSize(horizontal: false, vertical: true)
                .padding(0)
        }
        
        var body: some View {
            HStack {
                if url != nil {
                    HStack(alignment: .center, spacing: 4) {
                        if iconOnRight {
                            link
                                .padding(.trailing, 4)
                            icon
                        } else {
                            icon
                                .padding(.trailing, 4)
                            link
                        }
                    }
                }
                else {
                    EmptyView()
                }
            }
        }
    }
}
