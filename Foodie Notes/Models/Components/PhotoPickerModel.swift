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
    struct ImageAndThumb {
        let imageData:Data;
        let thumbData:Data;
    }
    
    private var pickedMedia: [Media]?
    private var onLoadedClosure: (([ImageAndThumb]) -> Void)?;
    
    @Published var loaded:Bool = false;
    @Published var hasNewPickedImages:Bool = false;
    
    func load(pickedMedia: [Media], onLoaded:@escaping ([ImageAndThumb]) -> Void) {
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
        
        var images:[ImageAndThumb] = []
        
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
            do {
                if let data = try await task.value {
                    // Attempt to generate a thumbnail.  If that works, save the image.
                    if let thumbnail = await ImageDataService.createThumbnailFor(data) {
                        images.append(ImageAndThumb(imageData: data, thumbData: thumbnail))
                    }
                }
            } catch {
                // Don't append anything, we can't load this image.
            }
        }
        
        onLoadedClosure!(images)
        self.loaded = true
        self.hasNewPickedImages = false;
    }
}

