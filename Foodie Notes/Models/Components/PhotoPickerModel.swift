//
//  PhotoPickerModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/6/24.
//

import Foundation
import UIKit
import ExyteMediaPicker

class PhotoPickerModel: ObservableObject {
    private var imageService: ImageDataService = .shared

    private var pickedMedia: [Media]?
    private var onLoadedClosure: (([Photo]) -> Void)?;
    
    @Published var loaded:Bool = false;
    @Published var hasNewPickedImages:Bool = false;
    
    func load(pickedMedia: [Media], onLoaded:@escaping ([Photo]) -> Void) {
        self.pickedMedia = pickedMedia
        self.onLoadedClosure = onLoaded
        self.hasNewPickedImages = true;
        self.loaded = false;
    }
    
    // TODO: will freeze the app if a lot of images are chosen, figure out how to do this async.
    @MainActor func onStart() async {
        // If we're loaded already, don't load again.
        guard !self.loaded else { return }
        // If we don't have any media to load, we're done.
        guard pickedMedia != nil  && onLoadedClosure != nil else { return }
        
        var images:[Photo] = []
        
        // Fetch URLs from picked photo in this session.
        for media in self.pickedMedia! {
            guard media.type == .image else { continue }
            
            let url = await media.getURL()
            guard let url = url else { continue }
            
            // Attempt to load the data.
            let task = Task<Data?, Error> {
                guard let data = try? Data(contentsOf: url) else {
                    return nil
                }
                return data;
            }
            var data:Data;
            do {
                data = (try await task.value)!
            } catch {
                // Don't append anything, we can't load this image.
                continue
            }
            
            // Save the full image, if we can...
            if let savedFull = await imageService.getSavedImageFor(LoadedImage(imgData: data)) {
                // Attempt to generate a thumbnail, if we can...
                if let thumbnail = await ImageDataService.createThumbnailFor(data) {
                    // Save the thumb, if we can...
                    if let savedThumb = await imageService.getSavedImageFor(LoadedImage(imgData: thumbnail)) {
                        // We have a full photo!
                        images.append(Photo(full: savedFull, thumb: savedThumb))
                    }
                }
            }
        }
        
        onLoadedClosure!(images)
        self.loaded = true
        self.hasNewPickedImages = false;
    }
}

