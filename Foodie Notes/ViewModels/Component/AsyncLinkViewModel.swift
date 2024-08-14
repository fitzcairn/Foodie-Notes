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
        let charsInName = Set(name.split(separator: ""))
       
        WebSearchService.getSearchResultsFor(url) { searchNameAndUrls in
            var resultUrl:URL?
            
            // Take the first link that looks like a reasonably helpful one.
            for (searchName, searchUrl) in searchNameAndUrls {
                if (searchUrl != nil && searchName != nil && searchUrl!.absoluteString.contains("/restaurant/")) {
                    
                    // Pull out only the restaurant name.
                    let searchName = searchName!.split(separator: " - ").first!
                    
                    // Allow for mispelling; if >50% of the characters intersect, accept the match,
                    // choosing to trust in search relevance.
                    let charsInSearchName = Set(searchName.split(separator: ""))
                    let overlap = charsInName.intersection(charsInSearchName)
                    let union = charsInName.union(charsInSearchName)
                    let perc = Float(overlap.count) / Float(union.count)
                    if perc > 0.5 {
                        resultUrl = searchUrl;
                        break;
                    }
                }
            }
            DispatchQueue.main.async {
                self.link = resultUrl
                self.status = resultUrl == nil ? .none : .complete
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
