//
//  ConversionService.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/21/24.
//

import Foundation


// Service for handling save data conversion on model changes.
// Hack alert!!
class ConversionService {
    // July 21 - convert images saved as Pictures to the new hotness.
    static func convertPicturesToSavedImages(_ from:AppModel, imageService:ImageDataService = .shared) async -> AppModel {
        var toModel = AppModel()
        
        func convertError(_ err:String) -> Picture? {
            print(err)
            return nil;
        }
        
        func convert(_ from:Picture) async -> Picture? {
            guard(from.data != nil) else { return convertError("no data") }
            let fullImgData = from.data!
            var toPicture:Picture = from;
            
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
        
        for meal in from.getMeals() {
            var newMeal = meal;
            newMeal.pickedImage = await meal.pickedImage != nil ? convert(meal.pickedImage!) : nil
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
        
        return toModel
    }
    
    static let shared: ConversionService =  {
        let instance = ConversionService()
        // Configuration and setup if needed
        return instance
    }()
    private init() { }
}
