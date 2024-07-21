//
//  GuideLinkViewModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/20/24.
//

import Foundation
import SwiftSoup

class GuideLinkViewModel: SearchableConfig {
    var status: Status = .searching
    
    @Published var link:URL?
    
    func searchFor(name:String, guide:VenueGuide? = .michelin, city:String?, country:String?){
        guard let url = URL(
            string: constructLinkFor(guide: guide, name: name, city: city, country: country)
        ) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                self.handleClientError(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                self.handleServerError(response)
                return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "text/html",
               let data = data,
               let html = String(data: data, encoding: .utf8) {

                var guideLink:URL?
                
                do {
                    guideLink = try self.getFirstResultLinkFrom(html)
                } catch {
                    self.handleParseError()
                }

                DispatchQueue.main.async {
                    self.link = guideLink
                    self.status = guideLink == nil ? .none : .complete
                }
            }
        }
        task.resume()
    }
    
    private func handleClientError(_ error:Error) {
        status = .error
    }

    private func handleServerError(_ response:URLResponse?) {
        status = .error
    }
    
    private func handleParseError() {
        status = .error
    }
    
    private func getFirstResultLinkFrom(_ html:String) throws -> URL? {
        var guideLink:URL?
        
        let doc: Document = try SwiftSoup.parse(html)

        // Pull out a clean link from the first result.
        let firstResultElement = try doc.body()?.getElementById("links")
        let firstLinkElement = try firstResultElement?.getElementsByClass("result__url").first()

        if let firstLinkString = try firstLinkElement?.text() {
            guideLink = URL(string:"https://\(firstLinkString)")
        }
        
        return guideLink
    }
    
    private func constructLinkFor(guide:VenueGuide?, name:String, city:String?, country:String?) -> String {
        // Easiest to just ask DuckDuckGo for now.  Later, I'll host my own webservice for this.
        let baseUrl = "https://duckduckgo.com/html/?q="

        switch(guide ?? .michelin) {
        case .michelin:
            return "\(baseUrl)site%3Aguide.michelin.com+\(name.replacingOccurrences(of: " ", with: "+"))+\(city?.replacingOccurrences(of: " ", with: "+") ?? "")+\(country?.replacingOccurrences(of: " ", with: "+") ?? "")"
        }
    }
}
