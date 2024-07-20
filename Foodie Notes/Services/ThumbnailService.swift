//
//  ThumbnailService.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/20/24.
//

import Foundation
import UIKit

class ThumbnailService {

    // Attempt to generate a thumbnail, in two styles.
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
}
