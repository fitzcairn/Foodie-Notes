//
//  AsyncLabelRecognitionViewModel.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/26/24.
//

import Foundation
import Vision
import CoreImage.CIFilterBuiltins
import UIKit


// Only ~works for labels with text, but 50% is better than 0%!
class AsyncLabelRecognitionViewModel: AsyncLabelRecognitionConfig {
    @Published var status: Status = .loading
    @Published var subject:UIImage?
    @Published var text:[String]?
    @Published var name:String?
    @Published var link:URL?

    private var processingQueue = DispatchQueue(label: "ImageProcessingQueue")
    private var imageService: ImageDataService = .shared
    
    func recognizeWineLabelFor(_ img: SavedImage) {
        Task {
            guard let loadedImage = await imageService.getLoadedImageFor(img) else {
                print("Failed to load image \(img.id)")
                return
            }
            guard let uiImage = UIImage(data: loadedImage.imgData) else {
                print("Failed to create UIImage for \(loadedImage.id)")
                return
            }
            performRecognitionFor(uiImage)
        }
    }
    
    func findMoreInfoLinkFor(_ labelText:[String]) {
        let suffix = " - Wine-Searcher"
        
        guard let url = URL(
            string: WebSearchService.constructLinkFor(domain: "wine-searcher.com", query:labelText)
        ) else { return }
        
        WebSearchService.getSearchResultsFor(url) { searchNameAndUrls in
            var resultName:String = ""
            var resultUrl:URL?
            
            // Take the first link that looks like a reasonably helpful one.
            for (searchName, searchUrl) in searchNameAndUrls {
                if (searchUrl != nil && searchName != nil && !searchName!.contains(/[&|]/)) {
                    resultName = searchName!;
                    if (resultName.hasSuffix(suffix)) {
                        resultName = String(resultName.prefix(resultName.count - suffix.count))
                    }
                    resultUrl = searchUrl;
                    break;
                }
            }
            DispatchQueue.main.async {
                self.name = resultName
                self.link = resultUrl
                self.status = .complete
            }
        }
    }
    
    private func performRecognitionFor(_ image:UIImage) {
        guard let inputImage = CIImage(image: image) else {
            handleError("Failed to create CIImage")
            return
        }
        processingQueue.async {
            guard let maskImage = self.subjectMaskImageFor(inputImage) else {
                self.handleError("Failed to create mask image")
                return
            }
            let outputImage = self.apply(mask: maskImage, to: inputImage)
            
            // Not all wines have a nice pasted on label; if this bottle does, pull it out
            // and perspective correct so we can do better OCR.
            var labelImage = outputImage;
            if let label = self.detectLabelFor(outputImage) {
                labelImage = label
            }

            // Now do OCR to get whatever text we can pull from either label or bottle.
            let labelText = self.detectWineTextFor(labelImage)
            
            // Kick off defining a link if we have any recognized text.  Otherwise we'll need user assistance.
            if (!labelText.isEmpty) {
                self.findMoreInfoLinkFor(labelText)
            }
            
            // Save results we do have.
            DispatchQueue.main.async {
                self.subject = self.render(ciImage: labelImage).rotate(radians: .pi/2)
                self.text = labelText
            }
        }
    }

    private func detectWineTextFor(_ inputImage: CIImage) -> [String] {
        let handler = VNImageRequestHandler(ciImage: inputImage)
        var resultStrings:[String] = []
        
        let request = VNRecognizeTextRequest() { request, error in
            guard let results = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                self.handleError("Error: Text recognition failed.")
                return
            }
            
            for result in results {
                if let str = result.topCandidates(1).first?.string {
                    resultStrings.append(str)
                }
            }
        }
        request.usesLanguageCorrection = true // TODO: May want this off...
        
        do {
            try handler.perform([request])
        } catch {
            handleError(error)
            return resultStrings
        }
        
        return resultStrings
    }
    
    private func detectLabelFor(_ inputImage: CIImage) -> CIImage? {
        let handler = VNImageRequestHandler(ciImage: inputImage)
        let request = VNDetectRectanglesRequest()
        do {
            try handler.perform([request])
        } catch {
            handleError(error)
            return nil
        }
        // We should only have one label on the bottle.
        guard let result = request.results?.first as? VNRectangleObservation else {
            handleError("No observations found")
            return nil
        }
        // Mask out everything except our label.
        return doPerspectiveCorrection(result, for: inputImage)
    }
    
    private func doPerspectiveCorrection(_ observation: VNRectangleObservation, for inputImage: CIImage) -> CIImage {
        let topLeft = VNImagePointForNormalizedPoint(observation.topLeft, Int(inputImage.extent.width), Int(inputImage.extent.height))
        let topRight = VNImagePointForNormalizedPoint(observation.topRight, Int(inputImage.extent.width), Int(inputImage.extent.height))
        let bottomLeft = VNImagePointForNormalizedPoint(observation.bottomLeft, Int(inputImage.extent.width), Int(inputImage.extent.height))
        let bottomRight = VNImagePointForNormalizedPoint(observation.bottomRight, Int(inputImage.extent.width), Int(inputImage.extent.height))
        return inputImage.applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft": CIVector(cgPoint: topLeft),
            "inputTopRight": CIVector(cgPoint: topRight),
            "inputBottomLeft": CIVector(cgPoint: bottomLeft),
            "inputBottomRight": CIVector(cgPoint: bottomRight),
        ])
    }
    
    private func subjectMaskImageFor(_ inputImage: CIImage) -> CIImage? {
        let handler = VNImageRequestHandler(ciImage: inputImage)
        let request = VNGenerateForegroundInstanceMaskRequest()
        do {
            try handler.perform([request])
        } catch {
            handleError(error)
            return nil
        }
        guard let result = request.results?.first else {
            handleError("No observations found")
            return nil
        }
        do {
            let maskPixelBuffer = try result.generateScaledMaskForImage(forInstances: result.allInstances, from: handler)
            return CIImage(cvPixelBuffer: maskPixelBuffer)
        } catch {
            handleError(error)
            return nil
        }
    }
    
    private func apply(mask: CIImage, to image: CIImage) -> CIImage {
        let filter = CIFilter.blendWithMask()
        filter.inputImage = image
        filter.maskImage = mask
        filter.backgroundImage = CIImage.empty()
        return filter.outputImage!
    }
    
    private func render(ciImage: CIImage) -> UIImage {
        guard let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent) else {
            handleError("Failed to render CGImage")
            return UIImage()
        }
        return UIImage(cgImage: cgImage)
    }
    
    private func handleError(_ err:any Error) {
        return handleError(err.localizedDescription)
    }
    
    private func handleError(_ err:String) {
        print(err)
        DispatchQueue.main.async {
            self.status = .error
        }
    }
}
