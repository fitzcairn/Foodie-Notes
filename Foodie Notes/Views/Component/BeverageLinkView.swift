//
//  BeverageLinkView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/29/24.
//

import SwiftUI


struct BeverageLinkView : View {
    var infoLink:InfoLink?
    var img:SavedImage?
    
    var body: some View {
        if let link = infoLink {
            BeverageInfoLinkView(link:link)
        } else if let img = img {
            BeverageAsyncView(
                infoLink:Binding<InfoLink?>(
                    get: { infoLink },
                    set: { _ = $0 }), // For courses saved before this feature was added, we can do lookups on demand.
                img:img)
        } else {
            EmptyView()
        }
    }
}

struct BeverageEditLinkView : View {
    enum EditState {
        case view
        case editing
        case edited
    }
    
    @Binding var infoLink:InfoLink?;
    let img:SavedImage?
    
    @Environment(NetworkService.self) private var networkService
    
    @StateObject var labelRecModel:AsyncLabelRecognitionViewModel = AsyncLabelRecognitionViewModel()
    @State var searchTerms:String = "";
    @State var state:EditState = .view
    
    init(infoLink: Binding<InfoLink?>, img:SavedImage?) {
        self.img = img;
        self._infoLink = infoLink
        self._searchTerms = State(initialValue: self.infoLink?.name ?? "")
    }
    
    var body: some View {
        VStack {
            switch(state) {
            case .view:
                HStack {
                    if let link = infoLink {
                        BeverageInfoLinkView(link: link, edit: true)
                    } else if let img = img {
                        BeverageAsyncView(infoLink: $infoLink, img: img, edit: true)
                    } else {
                        EmptyView()
                    }
                    Spacer()
                }
                .onTapGesture {
                    state = .editing
                }
            case .editing:
                HStack {
                    FindImg()
                    StyledTextField(inputText: $searchTerms, prompt: "Tap to add search terms")
                    SaveImg()
                        .onTapGesture {
                            state = .edited;
                        }
                }
            case .edited:
                HStack {
                    if let img = img {
                        if searchTerms.isEmpty {
                            BeverageAsyncView(infoLink: $infoLink, img: img, edit: true)
                        } else {
                            BeverageAsyncView(infoLink: $infoLink, img: img, edit: true) { source in
                                source.findMoreInfoLinkFor([searchTerms])
                            }
                        }
                    } else {
                        EmptyView()
                    }
                    Spacer()
                }
                .onTapGesture {
                    searchTerms = infoLink?.name ?? ""
                    state = .editing
                }
            }
        }
        .padding(.top, 4)
    }
}
    
struct BeverageAsyncView : View {
    @Binding var infoLink:InfoLink?;
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
                linkContent: { BeverageInfoLinkView(link:InfoLink(name: labelRecModel.name, url:labelRecModel.link), edit:edit) },
                edit: edit,
                executeCompletion: executeCompletion
            )
            .onChange(of: labelRecModel.status) {
                if labelRecModel.status != .loading {
                    // Lookup completed; regardless of outcome make sure we don't repeat.
                    infoLink = InfoLink(name:labelRecModel.name, url:labelRecModel.link)
                }
            }
        } else {
            BeverageInfoLinkView(link:InfoLink(name: "No Internet Connection", url: URL(string: "")))
        }
    }
}

struct BeverageInfoLinkView: View {
    let link:InfoLink
    var edit:Bool = false;
    
    var body: some View {
        HStack {
            if let url = link.url, let name = link.name {
                if edit { EditImg() }
                else    { LinkImg() }
                Link(name, destination:url)
                    .font(.system(size:14, weight: .regular))
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(1)
            } else {
                EmptyView()
            }
            Spacer()
        }
    }
}

