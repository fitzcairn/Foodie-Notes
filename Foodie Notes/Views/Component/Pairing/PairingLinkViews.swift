//
//  PairingLinkViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/29/24.
//

import SwiftUI


struct RecogninzePairingView : View {
    @Binding var info:BeverageLookupInfo
    @Binding var picture:Picture?
    
    var body: some View {
        if let img = picture?.photo?.full {
            if info.imgIdRecognized == img.id {
                if info.url != nil {
                    PairingBeverageInfoLinkView(info:$info)
                } else {
                    // We previously tried and failed to find a match.
                    StatusText("Unable to recognize label.")
                }
            } else {
                // New image
                PairingBeverageInfoLinkAsyncView(info:$info, img:img)
            }
        } else {
            StatusText("Add the label photo")
        }
    }
}

struct PairingBeverageInfoLinkAsyncView : View {
    @Binding var info:BeverageLookupInfo;
    var img:SavedImage;
    
    @StateObject var labelRecModel:AsyncLabelRecognitionViewModel = AsyncLabelRecognitionViewModel()
    @Environment(NetworkService.self) private var networkService
    
    var body: some View {
        
        if networkService.isConnected {
            // Load link async, and update view.
            AsyncRecognizedPairingLabelView(
                source:labelRecModel,
                img:img,
                progressContent: {
                    StatusText("Attempting to recognize label...")
                },
                linkContent: {
                    PairingBeverageInfoLinkView(info:$info)
                },
                errorContent: {
                    StatusText("Unable to recognize label.")
                }
            )
            .onChange(of: labelRecModel.status) {
                if labelRecModel.status != .loading {
                    // Lookup completed; regardless of outcome make sure we don't repeat.
                    info.name = labelRecModel.name ?? ""
                    info.url = labelRecModel.link
                    info.imgIdRecognized = img.id
                }
                if labelRecModel.status == .complete && info.name.isEmpty {
                    info.name = info.name
                }
            }
        } else {
            StatusText("Label recognition requires an internet connection.")
        }
    }
}

private struct StatusText : View {
    let text:String;
    init(_ text: String) {
        self.text = text
    }
    var body: some View {
        FoodieText(text, Colors.TextStaticTextSecondary, size:12, weight:.semibold)
    }
}

struct PairingBeverageInfoLinkView: View {
    @Binding var info:BeverageLookupInfo
    
    var body: some View {
        if let url = info.url, !info.name.isEmpty {
            HStack(alignment: .center, spacing: 4) {
                Link("Wine Searcher", destination:url)
                    .font(Font.custom("Nunito", size: 12).weight(.semibold))
                    .foregroundColor(Colors.TextActionTextAction)
                    .buttonStyle(.borderless)
                    .padding(0)
                
                Link("\u{e911}", destination:url)
                    .font(Font.custom("foodie-icons", size: 24))
                    .foregroundColor(Colors.TextActionTextAction)
                    .buttonStyle(.borderless)
                    .padding(0)
            }
        } else if !info.name.isEmpty {
            let url = URL(string:WebSearchService.constructLinkFor(baseUrl:"https://www.wine-searcher.com/find/", query:[info.name]))!
            HStack(alignment: .center, spacing: 4) {
                Link("Wine Searcher", destination:url)
                    .font(Font.custom("Nunito", size: 12).weight(.semibold))
                    .foregroundColor(Colors.TextActionTextAction)
                    .buttonStyle(.borderless)
                    .padding(0)
                
                Link("\u{e911}", destination:url)
                    .font(Font.custom("foodie-icons", size: 24))
                    .foregroundColor(Colors.TextActionTextAction)
                    .buttonStyle(.borderless)
                    .padding(0)
            }
            .onAppear() {
                info.url = url;
            }
        } else {
            EmptyView()
        }
    }
}
