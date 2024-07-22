//
//  ModelIOService.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/16/24.
//

import Foundation

class ModelIOService {
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("appmodel.data")
    }
    
    static func fileURLFor(_ model:any Identifiable) throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("\(model.id).data")
    }
 
    static func loadAppModel() async throws -> AppModel {
        let task = Task<AppModel, Error> {
            let fileURL = try ModelIOService.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return AppModel()
            }
            print(fileURL)
            let appModel = try JSONDecoder().decode(AppModel.self, from: data)
            
            return appModel
        }
        let appModel = try await task.value
        return await ConversionService.convert(appModel)
    }
    
    static func saveAppModel(model:AppModel) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(model)
            let outfile = try Self.fileURL()
            //try data.write(to: outfile)
        }
        _ = try await task.value
    }

    static func exportAsString(_ meal:Meal) -> String {
        var str = "I ate \(meal.courses.count) courses during a meal at \(meal.venue.name) on \(meal.date.formatted(date: .complete, time: .omitted)).  I rated it \(meal.rating) stars.  "
        
        if let city = meal.venue.city, let country = meal.venue.country {
            str += "\(meal.venue.name) is located in \(city), \(country).  "
        }
        if !meal.cuisines.isEmpty {
            str += "The food served is '\(meal.cuisines.map({$0.displayName}).joined(separator: ", "))'.  "
        }
        if let michelin = meal.venue.michelin {
            switch(michelin) {
            case .bibGourmand:
                str += "At time of dining, Michelin rates this restaurant as a Bib Gourmand.  "
            case .oneStar:
                str += "At time of dining, Michelin rates this restaurant as one star.  "
            case .twoStar:
                str += "At time of dining, Michelin rates this restaurant as two stars.  "
            case .threeStar:
                str += "At time of dining, Michelin rates this restaurant as three stars.  "
            }
        }

        if !meal.notes.isEmpty {
            str += "\n\nOverall, I thought: '\(meal.notes)'\n\n"
        }
        if !meal.menu.notes.isEmpty {
            str += "My notes on the menu were: '\(meal.menu.notes)'\n\n"
        }
 
        if (!meal.courses.isEmpty) {
            str += "Here are my notes for each course:\n"
            for (index, course) in meal.courses.enumerated() {
                str += "  Course \(index + 1) was named \(course.name), and rated it \(course.rating) stars\n"
                if (!course.food.notes.isEmpty) {
                    str += "  My thoughts on the dish: '\(course.food.notes)'\n"
                }
                if (!course.beveragePairing.notes.isEmpty) {
                    str += "  My thoughts on the beverage pairing: '\(course.food.notes)'\n"
                }
                if (course.beveragePairing.sameAsPrevious != nil && course.beveragePairing.sameAsPrevious!) {
                    str += "  The pairing was shared with the previous course.\n"
                }
            }
        }
        return str;
    }

}
