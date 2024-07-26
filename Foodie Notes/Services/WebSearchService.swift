//
//  WebSearchService.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/26/24.
//

import Foundation
import SwiftSoup

class WebSearchService {
    
    static func getFirstSearchResultFor(_ url:URL, completion:@escaping ((String?, URL?)) -> Void) {
        executeSearch(url) { html in
            completion(try self.getFirstResultLinkFrom(html))
        }
    }
    
    static func getSearchResultsFor(_ url:URL, completion:@escaping ([(String?, URL?)]) -> Void) {
        executeSearch(url) { html in
            completion(try self.getResultLinksFrom(html))
        }
    }
    
    static func constructLinkFor(domain:String, query:[String]) -> String {
        // Easiest to just ask DuckDuckGo for now.  Later, I'll host my own webservice for this.
        let baseUrl = "https://duckduckgo.com/html/?q="
        
        return "\(baseUrl)site%3A\(domain)+\(query.joined(separator: " ").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
    }
    
    static private func getResultLinksFrom(_ html:String) throws -> [(String?, URL?)] {
        let doc: Document = try SwiftSoup.parse(html)
        var resultList:[(String?, URL?)] = []
        
        if let results = try doc.body()?.getElementById("links") {
            for resultBody in try results.getElementsByClass("result__body") {
                let text = try resultBody.getElementsByClass("result__a").first()?.text()
                let link = try resultBody.getElementsByClass("result__url").first()?.text()
                resultList.append((text, URL(string:"https://\(link!)")))
            }
        }
        return resultList
    }
    
    static private func getFirstResultLinkFrom(_ html:String) throws -> (String?, URL?) {
        var firstLink:URL?
        let doc: Document = try SwiftSoup.parse(html)

        let results = try doc.body()?.getElementById("links")
        let text = try results?.getElementsByClass("result__a").first()?.text()
        let link = try results?.getElementsByClass("result__url").first()?.text()
        
        if link != nil && !link!.isEmpty {
            firstLink = URL(string:"https://\(link!)")
        }
        return (text, firstLink)
    }
    
    static private func executeSearch(_ url:URL, completion:@escaping ((String) throws -> Void)) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "text/html",
               let data = data,
               let html = String(data: data, encoding: .utf8) {
                do {
                    try completion(html)
                } catch {
                    return;
                }
            }
        }
        task.resume()
    }
}
