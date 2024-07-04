//
//  PhotoView.swift
//  Foodie Notes
//
//  Credit: modified from MediaCell.swift.
//
//  Created by Steve Martin on 7/4/24.
//

import SwiftUI
import ExyteMediaPicker

struct PhotoView: View {
    @StateObject var viewModel: PhotoViewModel

    var body: some View {
        GeometryReader { g in
            VStack {
                if let url = viewModel.imageUrl {
                    AsyncImage(url: url) { phase in
                        if case let .success(image) = phase {
                            image
                                .resizable()
                                .scaledToFill()
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .frame(width: g.size.width, height: g.size.height)
            .clipped()
        }
        .task {
            await viewModel.onStart()
        }
        .onDisappear {
            viewModel.onStop()
        }
    }
}
