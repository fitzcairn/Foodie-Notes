//
//  AsyncPhotoViewModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/21/24.
//

import Foundation


@MainActor
class AsyncPhotoViewModel: AsyncImageConfig {
    private var imageService: ImageDataService = .shared
    var status: Status = .loading

    @Published var loadedImg:LoadedImage?;
    
    func loadImageFor(_ img: SavedImage) {
        Task {
            let loadedImg:LoadedImage? = await imageService.getLoadedImageFor(img)
                        
            DispatchQueue.main.async {
                self.loadedImg = loadedImg
                self.status = loadedImg == nil ? .none : .complete
            }
        }
    }
    
    private func handleError() {
        self.status = .error
    }
}
