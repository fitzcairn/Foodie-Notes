//
//  AsyncRecognizedWineLabelView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/26/24.
//

import SwiftUI

struct AsyncRecognizedWineLabelView<Source:AsyncLabelRecognitionConfig, ProgressContent: View, LinkContent: View>: View {
    @ObservedObject var source:Source
    let img: SavedImage;
    let progressContent: ProgressContent;
    let linkContent: LinkContent;
    let edit:Bool;
    let executeCompletion: (Source) -> Void;
    
    init(source: Source, img:SavedImage, @ViewBuilder progressContent: () -> ProgressContent, @ViewBuilder linkContent: () -> LinkContent, edit:Bool = false, executeCompletion: ((Source) -> Void)? = nil) {
        self.source = source
        self.img = img;
        self.progressContent = progressContent()
        self.linkContent = linkContent()
        self.edit = edit;
        if let completion = executeCompletion {
            self.executeCompletion = completion
        } else {
            self.executeCompletion = { source in source.recognizeWineLabelFor(img) }
        }
    }
    
    var body: some View {
        switch source.status {
        case .loading:
            progressContent
                .onAppear {
                    self.executeCompletion(self.source)
                }
        case .complete:
            linkContent
        case .error, .none:
            if edit {
                EditImg()
                Text("Tap to ID pairing")
                    .font(.system(size:14, weight: .regular))
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(1)
            } else {
                EmptyView()
            }
        }
    }
}
