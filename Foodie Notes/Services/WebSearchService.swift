//
//  WebSearchService.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/26/24.
//

import Foundation
import SwiftSoup

class WebSearchService {
    
    static func getFirstSearchResultFor(_ url:URL, suffixMask:String?, completion:@escaping ((String?, URL?)) -> Void) {
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
                    completion(try self.getFirstResultLinkFrom(html, suffixMask: suffixMask))
                } catch {
                    return;
                }
            }
        }
        task.resume()
    }
    
    static func constructLinkFor(domain:String, query:[String]) -> String {
        // Easiest to just ask DuckDuckGo for now.  Later, I'll host my own webservice for this.
        let baseUrl = "https://duckduckgo.com/html/?q="
        return "\(baseUrl)site%3A\(domain)+\(query.joined(separator: " ").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
    }
    
    static private func getFirstResultLinkFrom(_ html:String, suffixMask:String?) throws -> (String?, URL?) {
        var guideLink:URL?
        
        let doc: Document = try SwiftSoup.parse(html)

        // Pull out a clean link from the first result.
        let results = try doc.body()?.getElementById("links")
        let text = try results?.getElementsByClass("result__a").first()?.text()
        let link = try results?.getElementsByClass("result__url").first()?.text()

        if link != nil && !link!.isEmpty {
            guideLink = URL(string:"https://\(link!)")
        }
        
        if text != nil && suffixMask != nil && text!.hasSuffix(suffixMask!){
            return (String(text!.prefix(text!.count - suffixMask!.count)), guideLink)
        }
        return (text, guideLink)
    }
    
    static let shared: WebSearchService =  {
        let instance = WebSearchService()
        return instance
    }()
    private init() { }
}
