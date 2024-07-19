//
//  WebFetchService.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/19/24.
//

import Foundation
import SwiftSoup

class WebFetchService : ObservableObject {
    enum Status {
        case notStarted
        case working
        case notFound
        case complete
        case error
    }
    
    @Published var link:URL?
    var status:Status = .notStarted

    func fetchMichelinGuideLinkFor(name:String, city:String?, country:String?) {
        guard let url = URL(string: constructLinkFor(name: name, city: city, country: country)) else { return }
        
        self.link = nil;
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            self.status = .working
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
                    let doc: Document = try SwiftSoup.parse(html)

                    // Pull out a clean link from the first result.
                    let firstResultElement = try doc.body()?.getElementById("links")
                    let firstLinkElement = try firstResultElement?.getElementsByClass("result__url").first()

                    if let firstLinkString = try firstLinkElement?.text() {
                        guideLink = URL(string:"https://\(firstLinkString)")
                    }
                } catch {
                    self.handleParseError()
                }

                DispatchQueue.main.async {
                    self.link = guideLink
                    self.status = guideLink == nil ? .notFound : .complete
                }
            }
        }
        task.resume()
    }

    private func constructLinkFor(name:String, city:String?, country:String?) -> String {
        // Easiest to just ask DuckDuckGo for now.
        // TODO: Later, host my own webservice for this.
        let url = "https://duckduckgo.com/html/?q=site%3Aguide.michelin.com+\(name.replacingOccurrences(of: " ", with: "+"))+\(city?.replacingOccurrences(of: " ", with: "+") ?? "")+\(country?.replacingOccurrences(of: " ", with: "+") ?? "")"
        return url;
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

}
