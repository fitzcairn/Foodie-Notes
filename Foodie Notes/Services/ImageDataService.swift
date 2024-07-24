//
//  ImageService.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/21/24.
//

import Foundation
import UIKit

class ImageDataService {
    // App-wide registry of loaded images.  Must be thread safe.
    private var loadedImagesById = ThreadSafeDictionary<ImageId,LoadedImage>()

    func getLoadedImageFor(_ img:SavedImage) async -> LoadedImage? {
        // Check if we have this loaded already, if so return.
        if let cachedImg = loadedImagesById[img.id] {
            return cachedImg;
        }
 
        // Otherwise, we need to load from disk, index it, return it.
        let task = Task<LoadedImage, Error> {
            let data = try Data(contentsOf: ModelIOService.fileURLFor(img))
            let loadedImage = try JSONDecoder().decode(LoadedImage.self, from: data)
            return loadedImage
        }
        do {
            let loadedImage = try await task.value
            guard(loadedImage.id == img.id) else { return nil }
            return index(loadedImage);
        } catch {
            return nil;
        }
    }
    
    func getSavedImageFor(_ img:LoadedImage) async -> SavedImage? {
        // Make sure we cache this loaded image -- it was likely just created.
        _ = index(img)
        
        // Save the image data to disk.
        do {
            let outfile = try ModelIOService.fileURLFor(img)            
            let task = Task {
                let data = try JSONEncoder().encode(img)
                try data.write(to: outfile)
            }
            _ = try await task.value
            return SavedImage(id: img.id)

        } catch {
            return nil;
        }
    }
    
    static func createThumbnailFor(_ image:Data) async -> Data? {
        if let thumbnail = await UIImage(data: image)?.byPreparingThumbnail(ofSize:PhotoDimensions.thumbSize) {
            return thumbnail.pngData()
        }
        return nil;
    }

    static func createThumbnailFor(_ image:Data, onSuccess:@escaping (Data?) -> Void) {
        UIImage(data: image)?.prepareThumbnail(of:PhotoDimensions.thumbSize) { thumbnail in
            if let thumbnail = thumbnail {
                onSuccess(thumbnail.pngData())
            }
        }
    }
    
    private func index(_ img:LoadedImage) -> LoadedImage {
        loadedImagesById[img.id] = img;
        return img;
    }
    
    // Create as a thread-safe singleton.
    static let shared =  {
        let instance = ImageDataService()
        return instance
    }()
    private init() { }
}

