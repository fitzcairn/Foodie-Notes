//
//  ConversionService.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/21/24.
//

import Foundation


// Service for handling save data conversion on model changes.
class ConversionService {
    static func convert(_ from:AppModel) async -> AppModel {
        return await convertLocation(from)
        //return from;
    }
    
    // July 22 - change up how location is stored.  Luckily, this is simple.
    static func convertLocation(_ from:AppModel) async -> AppModel {
        var toModel = AppModel()
        
        
        for meal in from.getMeals() {
            var newMeal = meal;
            
            func anyNotNil(_ fields:Array<Optional<Any>>) -> Bool {
                for f in fields {
                    guard(f == nil) else { return true }
                }
                return false;
            }
            
            if anyNotNil([newMeal.venue.latitude, newMeal.venue.longitude, newMeal.venue.city, newMeal.venue.country]) {
                newMeal.venue.location = Location(lat: newMeal.venue.latitude, long: newMeal.venue.longitude, city: newMeal.venue.city, country: newMeal.venue.country)
                toModel.index(newMeal)
            }
        }
        
        // Save out the new model to complete the conversion.
        do {
            try await ModelIOService.saveAppModel(model: toModel)
        } catch {
            // Full stop, something went seriously wrong.
            fatalError(error.localizedDescription)
        }
        return toModel;
    }
    
    // July 21 - convert images saved as Pictures to the new hotness.
    /*static func convertPicturesToSavedImages(_ from:AppModel, imageService:ImageDataService = .shared) async -> AppModel {
        var toModel = AppModel()
        
        func convertError(_ err:String) -> Picture? {
            print(err)
            //fatalError(err)
            return nil;
        }
        
        func convert(_ from:Picture?) async -> Picture? {
            // If it doesn't exist, or if has a photo, no need to convert
            guard(from != nil) else { return from }
            guard(from!.photo == nil) else { return from }
            // No data to convert?  Return nothing.
            guard(from!.data != nil) else { return convertError("no data") }

            var toPicture:Picture = from!
            let fullImgData = toPicture.data!
            toPicture.data = nil; // Don't need to save data in the model anymore.
            
            // Save the full image data to disk.
            let savedFullImg = await imageService.getSavedImageFor(LoadedImage(imgData: fullImgData))
            guard(savedFullImg != nil) else { return convertError("couldn't save full image") }

            // Create the thumbnail and save it to disk.
            let thumbImgData = await ImageDataService.createThumbnailFor(fullImgData)
            guard(thumbImgData != nil) else { return convertError("couldn't make thumb") }
            let savedThumbImg = await imageService.getSavedImageFor(LoadedImage(imgData: thumbImgData!))
            guard(savedThumbImg != nil) else { return convertError("couldn't save thumb image") }
            
            // Create the new Photo and save.
            toPicture.photo = Photo(full: savedFullImg!, thumb: savedThumbImg!)
            return toPicture
        }
        
        func convertPicturesAndNotes(_ from:PicturesAndNotes) async -> PicturesAndNotes {
            var newPictures:[Picture] = []
            for picture in from.pictures {
                if let newPicture = await convert(picture) {
                    newPictures.append(newPicture)
                }
            }
            var newPicsAndNotes = from
            newPicsAndNotes.pictures = newPictures
            return newPicsAndNotes;
        }

        func skip(_ from:Picture?) -> Bool {
            // If it doesn't exist, or if has a photo, no need to convert
            return from == nil || from!.photo != nil;
        }
        
        for meal in from.getMeals() {
            var newMeal = meal;
            newMeal.pickedImage = await convert(meal.pickedImage)
            newMeal.menu = await convertPicturesAndNotes(meal.menu)
            
            var newCourses:[Course] = []
            for course in meal.courses {
                var newCourse = course
                newCourse.food = await convertPicturesAndNotes(course.food)
                newCourse.beveragePairing = await convertPicturesAndNotes(course.beveragePairing)
                newCourse.pickedImage = await course.pickedImage != nil ? convert(course.pickedImage!) : nil
                
                newCourses.append(newCourse)
            }
            newMeal.courses = newCourses
            
            toModel.index(newMeal)
        }
        
        // Save out the new model to complete the conversion.
        do {
            try await ModelIOService.saveAppModel(model: toModel)
        } catch {
            // Full stop, something went seriously wrong.
            fatalError(error.localizedDescription)
        }
        
        return toModel
    }*/
    
    static let shared: ConversionService =  {
        let instance = ConversionService()
        // Configuration and setup if needed
        return instance
    }()
    private init() { }
}
