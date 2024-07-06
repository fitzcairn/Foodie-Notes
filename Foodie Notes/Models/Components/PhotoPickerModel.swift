//
//  PhotoPickerModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/6/24.
//

import Foundation
import ExyteMediaPicker

class PhotoPickerModel: ObservableObject {
    private var pickedMedia: [Media]?
    private var onLoadedClosure: (([URL]) -> Void)?;
    
    @Published var loaded:Bool = false;
    @Published var hasNewPickedImages:Bool = false;
    
    func load(pickedMedia: [Media], onLoaded:@escaping ([URL]) -> Void) {
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
        
        // Fetch URLs from picked photo in this session.
        var urls:[URL] = []
        
        for media in pickedMedia! {
            guard media.type == .image else { continue }
            
            let url = await media.getURL()
            guard let url = url else { continue }
           
            urls.append(url)
        }

        onLoadedClosure!(urls)
        self.loaded = true
        self.hasNewPickedImages = false;
    }
}

