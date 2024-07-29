//
//  AsyncRecognizedWineLabelView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/26/24.
//

import SwiftUI

struct AsyncRecognizedWineLabelView<Source:AsyncLabelRecognitionConfig, ProgressContent: View, LinkContent:View>: View {
    @ObservedObject var source:Source
    let img: SavedImage;
    let progressContent: ProgressContent;
    let linkContent: LinkContent;
    
    init(source: Source, img:SavedImage, @ViewBuilder progressContent: () -> ProgressContent, @ViewBuilder linkContent: () -> LinkContent) {
        self.source = source
        self.img = img;
        self.progressContent = progressContent()
        self.linkContent = linkContent()
    }
    
    var body: some View {
        switch source.status {
        case .loading:
            progressContent
                .onAppear {
                    source.recognizeWineFor(img)
                }
        case .complete:
            linkContent
        case .error, .none:
            EmptyView()
        }
    }
}
