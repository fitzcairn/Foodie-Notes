//
//  BeverageLinkView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/29/24.
//

import SwiftUI


struct RecogninzePairingView : View {
    @Binding var infoLink:BeverageLookupInfo
    var img:SavedImage?
    
    var body: some View {
        if let link = infoLink.url {
            BeverageInfoLinkView(link:$infoLink)
        } else if let img = img {
            BeverageAsyncView(infoLink:$infoLink, img:img)
        } else {
            EmptyView()
        }
    }
}

struct BeverageAsyncView : View {
    @Binding var infoLink:BeverageLookupInfo;
    var img:SavedImage;
    var edit:Bool = false;
    var executeCompletion: ((AsyncLabelRecognitionViewModel) -> Void)? = nil
    
    @StateObject var labelRecModel:AsyncLabelRecognitionViewModel = AsyncLabelRecognitionViewModel()
    @Environment(NetworkService.self) private var networkService
    
    var body: some View {
        
        if networkService.isConnected {
            // Load link async, and update view.
            AsyncRecognizedWineLabelView(
                source:labelRecModel,
                img:img,
                progressContent: { Searching() },
                // Can safely unwrap link due to switch statement in AyncGuideLink
                linkContent: { BeverageInfoLinkView(link:BeverageLookupInfo(name: labelRecModel.name ?? "", url:labelRecModel.link), edit:edit) },
                edit: edit,
                executeCompletion: executeCompletion
            )
            .onChange(of: labelRecModel.status) {
                if labelRecModel.status != .loading {
                    // Lookup completed; regardless of outcome make sure we don't repeat.
                    infoLink = BeverageLookupInfo(name:labelRecModel.name ?? "", url:labelRecModel.link)
                }
            }
        } else {
            BeverageInfoLinkView(link:BeverageLookupInfo(name: "No Internet Connection", url: URL(string: "")))
        }
    }
}

struct BeverageInfoLinkView: View {
    @Binding var link:BeverageLookupInfo
    
    var body: some View {
        if let url = link.url, !link.name.isEmpty {
            HStack {
                LinkImg()
                Link(link.name, destination:url)
                    .font(.system(size:14, weight: .regular))
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(1)
            }
        } else {
            EmptyView()
        }
    }
}
