//
//  ImageService.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/21/24.
//

import Foundation
import UIKit

/*
 Some notes on the new photos lazy load:
 
 Pre:
 - Need a ViewModel for photos that maintains a list that is selectively serialized to disk that can async load them.
 - Need the AppModel to maintain a list of SavedImages.

 Method:
 - Maintain an ID > SavedImage dict as part of the model.  This is loaded/saved to disk regularly.
 - Maintain a dict of ID > LoadedImages as part of the viewModel.  This is NOT saved to disk.
 - When a photo is chosen (created) during meal/course edit/create:
    - Create the LoadedImage, create the Photo, save in Picture model.
    - Add to dictionary of ID > LoadedImages.
    - ID for loaded photo is saved in the meal/course model.
 - When a meal is written to disk:
    - For each LoadedImage, if not saved:
      - Save to disk.
      - Create a SavedImage is created with the same Id as the LoadedImage.
      - Update ID > SavedImage dict.
      - Save ID > SavedImage dict to disk.
 - When a photo is viewed (thumb or full)
    - First check in ID > LoadedImages.  If found, return and continue.
    - Then check in ID > SavedImages.  If found, load the photo into ID > LoadedImage, return and continue.
    - Else nil
 */

class ImageDataService {
    // App-wide registry of loaded images.
    private var loadedImagesById:[ImageId:LoadedImage] = [:];

    func getLoadedImageFor(_ img:SavedImage) async -> LoadedImage? {
        // Check if we have this loaded already, if so return.
        if let cachedImg = loadedImagesById[img.id] {
            return cachedImg;
        }
 
        // Otherwise, we need to load from disk, index it, return it.
        let task = Task<LoadedImage, Error> {
            let data = try Data(contentsOf: img.file)
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
        // Save the image data to disk.
        do {
            let outfile = try ModelIOService.fileURLFor(img)
            
            let task = Task {
                let data = try JSONEncoder().encode(img)
                try data.write(to: outfile)
            }
            _ = try await task.value

            // Create and return SavedImage
            return SavedImage(id: img.id, file: outfile)

        } catch {
            return nil;
        }
    }
    
    // Method that runs synchronousely
    
    
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
        // Configuration and setup if needed
        return instance
    }()
    private init() { }
}

