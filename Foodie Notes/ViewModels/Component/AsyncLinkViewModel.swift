//
//  AsyncLinkViewModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/20/24.
//

import Foundation
import SwiftSoup

class AsyncLinkViewModel: AsyncSearchConfig {
    var status: Status = .loading
    
    @Published var link:URL?
    
    func searchFor(name:String, guide:VenueGuide? = .michelin, city:String?, country:String?){
        guard let url = URL(
            string: WebSearchService.constructLinkFor(
                domain:getGuideDomainFor(guide),
                query: [name, city ?? "", country ?? ""])
        ) else { return }
        
        WebSearchService.getFirstSearchResultFor(url) { (_, guideLink) in
            DispatchQueue.main.async {
                self.link = guideLink
                self.status = guideLink == nil ? .none : .complete
            }
        }
    }
    
    private func getGuideDomainFor(_ guide:VenueGuide?) -> String {
        switch(guide ?? .michelin) {
        case .michelin:
            return "guide.michelin.com"
        }
    }
}
