//
//  Constants.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/7/24.
//

import Foundation

enum PhotoDimensions {
    static let photoWidth:CGFloat = 64;
    static let photoHeight:CGFloat = 64;
    static let thumbSize:CGSize = CGSize(width:PhotoDimensions.photoWidth, height:PhotoDimensions.photoHeight)
}

enum SectionTitle {
    static let food = "Food"
    static let beverage = "Drink Pairing"
    static let date = "When Enjoyed"
    static let notes = "Overall Notes"
    static let menus = "Menu[s]"
    static let courses = "Courses"
    static let cuisine = "Cuisine[s]"
}

enum ViewTitle {
    static let viewMeal = "View Meal"
    static let editMeal = "Edit Meal"
    static let createMeal = "Add a Meal"
    static let viewCourse = "View Course"
    static let editCourse = "Edit Course"
    static let createCourse = "Add a Course"
    static let listMeals = "Your Meals"
}

enum Michelin: String, Codable, CaseIterable {
    case bibGourmand = "bib-gourmand"
    case oneStar = "1star"
    case twoStar = "2star"
    case threeStar = "3star"
    
    var imgName: String {
        return self.rawValue
    }
}

enum VenueGuide: String, Codable, CaseIterable {
    case michelin = "Michelin Guide"
    
    var displayName: String {
        return self.rawValue
    }
}

enum Cuisine: String, Codable, CaseIterable {
    case afghan = "Afghan"
    case american = "American"
    case americanCalifornia = "American (California)"
    case americanNewEngland = "American (New England)"
    case americanSouthern = "American (Southern)"
    case argentine = "Argentine"
    case armenian = "Armenian"
    case austrian = "Austrian"
    case azerbaijani = "Azerbaijani"
    case bangladeshi = "Bangladeshi"
    case belgian = "Belgian"
    case bolivian = "Bolivian"
    case bosnian = "Bosnian"
    case brazilian = "Brazilian"
    case british = "British"
    case bulgarian = "Bulgarian"
    case burmese = "Burmese"
    case cambodian = "Cambodian"
    case canadian = "Canadian"
    case caribbean = "Caribbean"
    case chilean = "Chilean"
    case chinese = "Chinese"
    case colombian = "Colombian"
    case creole = "Creole"
    case croatian = "Croatian"
    case cuban = "Cuban"
    case czech = "Czech"
    case danish = "Danish"
    case dutch = "Dutch"
    case egyptian = "Egyptian"
    case ethiopian = "Ethiopian"
    case finnish = "Finnish"
    case filipino = "Filipino"
    case french = "French"
    case georgian = "Georgian"
    case german = "German"
    case ghanaian = "Ghanaian"
    case greek = "Greek"
    case hungarian = "Hungarian"
    case indian = "Indian"
    case indonesian = "Indonesian"
    case iranian = "Iranian"
    case iraqi = "Iraqi"
    case irish = "Irish"
    case italian = "Italian"
    case ivorian = "Ivorian"
    case jamaican = "Jamaican"
    case japanese = "Japanese"
    case jordanian = "Jordanian"
    case kazakh = "Kazakh"
    case kenyan = "Kenyan"
    case korean = "Korean"
    case laotian = "Laotian"
    case lebanese = "Lebanese"
    case malaysian = "Malaysian"
    case malian = "Malian"
    case malagasy = "Malagasy"
    case mexican = "Mexican"
    case mongolian = "Mongolian"
    case moroccan = "Moroccan"
    case nepali = "Nepali"
    case newZealand = "New Zealand"
    case nigerian = "Nigerian"
    case norwegian = "Norwegian"
    case pakistani = "Pakistani"
    case palestinian = "Palestinian"
    case panamanian = "Panamanian"
    case paraguayan = "Paraguayan"
    case peruvian = "Peruvian"
    case polish = "Polish"
    case portuguese = "Portuguese"
    case romanian = "Romanian"
    case russian = "Russian"
    case saudiArabian = "Saudi Arabian"
    case scottish = "Scottish"
    case senegalese = "Senegalese"
    case serbian = "Serbian"
    case singaporean = "Singaporean"
    case slovak = "Slovak"
    case slovenian = "Slovenian"
    case southAfrican = "South African"
    case spanish = "Spanish"
    case sriLankan = "Sri Lankan"
    case sudanese = "Sudanese"
    case swedish = "Swedish"
    case swiss = "Swiss"
    case syrian = "Syrian"
    case taiwanese = "Taiwanese"
    case tanzanian = "Tanzanian"
    case thai = "Thai"
    case tunisian = "Tunisian"
    case turkish = "Turkish"
    case ugandan = "Ugandan"
    case ukrainian = "Ukrainian"
    case uruguayan = "Uruguayan"
    case uzbek = "Uzbek"
    case venezuelan = "Venezuelan"
    case vietnamese = "Vietnamese"
    case welsh = "Welsh"
    case yemeni = "Yemeni"
    case zimbabwean = "Zimbabwean"
    
    var displayName: String {
        return self.rawValue
    }
}
