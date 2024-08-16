//
//  AsyncPhotoView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/21/24.
//

import SwiftUI

struct AsyncImageView<Source:AsyncImageConfig, ProgressContent: View, PhotoContent:View>: View {
    @ObservedObject var source:Source
    let img: SavedImage;
    @ViewBuilder let progressContent: ProgressContent;
    @ViewBuilder let photoContent: PhotoContent;
        
    var body: some View {
        switch source.status {
        case .loading:
            progressContent
                .onAppear {
                    source.loadImageFor(img)
                }
        case .complete:
            withAnimation {
                photoContent
            }
        case .error, .none:
            NoPhotoPlaceholderView()
        }
    }
}
