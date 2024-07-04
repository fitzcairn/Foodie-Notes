//
//  PhotoViewModel.swift
//  Foodie Notes
//
//  Credit: modified from MediaCell.swift.
//
//  Created by Steve Martin on 7/4/24.
//

import SwiftUI
import ExyteMediaPicker
import _AVKit_SwiftUI

final class PhotoViewModel: ObservableObject {
    let media: Media

    @Published var imageUrl: URL? = nil

    init(media: Media) {
        self.media = media
    }

    func onStart() async {
        guard imageUrl == nil && media.type == .image else { return }

        let url = await media.getURL()
        guard let url = url else { return }

        DispatchQueue.main.async {
            self.imageUrl = url
        }
    }

    func onStop() {
        imageUrl = nil
    }
}
