//
//  AsyncPhotoView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/21/24.
//

import SwiftUI

struct AsyncPhotoView<Source:AsyncImageConfig, ProgressContent: View, PhotoContent:View>: View {
    @ObservedObject var source:Source
    let img: SavedImage;
    let progressContent: ProgressContent;
    let photoContent: PhotoContent;
    
    init(source: Source, img:SavedImage, @ViewBuilder progressContent: () -> ProgressContent, @ViewBuilder photoContent: () -> PhotoContent) {
        self.source = source
        self.img = img;
        self.progressContent = progressContent()
        self.photoContent = photoContent()
    }
    
    var body: some View {
        switch source.status {
        case .loading:
            progressContent
                .onAppear {
                    source.loadImageFor(img)
                }
        case .complete:
            photoContent
        case .error, .none:
            EmptyView()
        }
    }
}
