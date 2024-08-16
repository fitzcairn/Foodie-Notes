//
//  Constants.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/7/24.
//

import Foundation
import SwiftUI


enum Colors {
    static let BackgroundBgPrimary: Color = Color(red: 1, green: 0.99, blue: 0.96)
    static let ShadowHigh: Color = Color(red: 0.53, green: 0.33, blue: 0.11).opacity(0.08)
    static let ShadowEdge: Color = Color(red: 0.53, green: 0.33, blue: 0.11).opacity(0.04)
    static let Delete: Color = Color(red: 0.92, green: 0.43, blue: 0.29)
    static let ShadowMed: Color = Color(red: 0.53, green: 0.33, blue: 0.11).opacity(0.06)
    static let TextActionTextAction: Color = Color(red: 0.95, green: 0.25, blue: 0.43)
    static let BorderStaticBorderSecondary: Color = Color(red: 0.88, green: 0.83, blue: 0.72)
    static let TextStaticTextPrompt: Color = Color(red: 0.12, green: 0.12, blue: 0.12).opacity(0.3)
    static let TextStaticTextPrimary: Color = Color(red: 0.12, green: 0.12, blue: 0.12)
    static let TextStaticTextSecondary: Color = Color(red: 0.55, green: 0.48, blue: 0.41)
    static let IconSecondary: Color = Color(red: 0.77, green: 0.72, blue: 0.66)
    static let IconActionSelected: Color = Color(red: 0.37, green: 0.32, blue: 0.27)
    static let IconActionEmpty: Color = Color(red: 0.77, green: 0.72, blue: 0.66)
    static let ShadowModal: Color = .black.opacity(0.24)
    static let FillActionFillActionSelected: Color = Color(red: 0.98, green: 0.35, blue: 0.46)
    static let ShadowHighVibrant: Color = Color(red: 0.95, green: 0.25, blue: 0.4).opacity(0.24)
    static let FillActionFillAction: Color = Color(red: 0.95, green: 0.25, blue: 0.43)
    static let FillStaticFillPrimary: Color = .white
    static let BorderActionBorderAction: Color = Color(red: 0.98, green: 0.35, blue: 0.46)
    static let FillStaticFillSecondary: Color = Color(red: 0.97, green: 0.94, blue: 0.87)
    static let FillActionFillActionPressed: Color = Color(red: 0.53, green: 0.08, blue: 0.19)
    static let FillActionFillActionPressedIcon: Color = Color(red: 0.99, green: 0.65, blue: 0.70)
    static let FillActionFillActionSubtle: Color = .white
    static let FillActionFillActionIconDisabled: Color = Color(red: 0.12, green: 0.12, blue: 0.12).opacity(0.3)
    static let FillActionFillDisabled: Color = Color(red: 0.12, green: 0.12, blue: 0.12).opacity(0.1)
    static let TextActionTextDisabled: Color = Color(red: 0.12, green: 0.12, blue: 0.12).opacity(0.3)
    static let BackgroundBgTertiary: Color = .white
    static let BorderStaticBorderTertiary: Color = Color(red: 0.12, green: 0.12, blue: 0.12).opacity(0.1)
    static let BorderStaticBorderSubtle: Color = Color(red: 0.12, green: 0.12, blue: 0.12).opacity(0.1)
    static let FillActionFillActionPressedSubtle: Color = Color(red: 0.97, green: 0.94, blue: 0.87)
    static let MichelinIconInactive: Color = Color(red: 0.78, green: 0.73, blue: 0.66)
    static let TextActionTextActionSelected: Color = Color(red: 0.12, green: 0.12, blue: 0.12)
    static let FillStaticFillTertiary: Color = Color(red: 0.12, green: 0.12, blue: 0.12).opacity(0.3)
    static let TextActionTextActionSelectedInvert: Color = .white
    static let BorderActionBorderActionSubtle: Color = Color(red: 0.88, green: 0.83, blue: 0.72)
    static let BorderActionBorderActionInvert: Color = Color(red: 0.32, green: 0.32, blue: 0.32)
    static let LoadingBorder: Color = Color(red: 0.78, green: 0.73, blue: 0.66)
    static let LoadingBoarderClear: Color = Color(red: 0.78, green: 0.73, blue: 0.66).opacity(0)
}

enum PhotoDimensions {
    static let photoThumbWidth:CGFloat = 128;
    static let photoThumbHeight:CGFloat = 128;
    static let thumbSize:CGSize = CGSize(width:PhotoDimensions.photoThumbWidth, height:PhotoDimensions.photoThumbHeight)
}


enum CourseNameSuggestion: String {
    case amuseBouche = "Amuse-Bouche"
    case canapé = "Canapé"
    case horsDoeuvre = "Hors d'Oeuvre"
    case snack = "Snack"
    case firstAppetizer = "First Appetizer"
    case secondAppetizer = "Second Appetizer"
    case soup = "Soup"
    case salad = "Salad"
    case appetizer = "Appetizer"
    case firstCourse = "First Course"
    case fishCourse = "Fish Course"
    case pastaCourse = "Pasta Course"
    case secondCourse = "Second Course"
    case poultryCourse = "Poultry Course"
    case meatCourse = "Meat Course"
    case gameCourse = "Game Course"
    case palateCleanser = "Palate Cleanser"
    case cheeseCourse = "Cheese Course"
    case preDessert = "Pre-Dessert"
    case dessert = "Dessert"
    case firstDessert = "First Dessert"
    case secondDessert = "Second Dessert"
    case mignardise = "Mignardise"
    case petitFours = "Petit Fours"
    case breadService = "Bread Service"
    
    func displayName() -> String {
        return self.rawValue
    }

    // Early = <= 3
    static var earlyCourses:[CourseNameSuggestion] {
        [.breadService, .amuseBouche, .canapé, .horsDoeuvre, .snack, .firstAppetizer, .secondAppetizer, .soup, .salad]
    }

    // Middle = 4 - 6
    static var middleCourses:[CourseNameSuggestion] {
        [.breadService, .firstAppetizer, .secondAppetizer, .soup, .salad, .firstCourse, .fishCourse, .pastaCourse, .secondCourse, .poultryCourse, .meatCourse, .gameCourse, .cheeseCourse, .preDessert]
    }
    
    // Late = >= 6
    static var lateCourses:[CourseNameSuggestion] {
        [.meatCourse, .gameCourse, .palateCleanser, .cheeseCourse, .preDessert, .dessert, .mignardise, .petitFours, .breadService, .secondDessert, .firstDessert]
    }
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

enum Michelin: String, Codable, CaseIterable, Comparable {
    case none = "\u{e91c}"
    case plate = "\u{e918}"
    case bibGourmand = "\u{e902}"
    case oneStar = "\u{e919}"
    case twoStar = "\u{e919}\u{e919}"
    case threeStar = "\u{e919}\u{e919}\u{e919}"
    
    private var sortOrder: Int {
        switch self {
        case .none:
            return 0
        case .plate:
            return 1
        case .bibGourmand:
            return 2
        case .oneStar:
            return 3
        case .twoStar:
            return 4
        case .threeStar:
            return 5
        }
    }

     static func ==(lhs: Michelin, rhs: Michelin) -> Bool {
        return lhs.sortOrder == rhs.sortOrder
    }

    static func <(lhs: Michelin, rhs: Michelin) -> Bool {
       return lhs.sortOrder < rhs.sortOrder
    }
    
    var displayName: String {
        switch self {
        case .none:
            return "Not Rated"
        case .plate:
            return "Michelin Plate"
        case .bibGourmand:
            return "Bib Gourmand"
        case .oneStar:
            return "1 Michelin Star"
        case .twoStar:
            return "2 Michelin Stars"
        case .threeStar:
            return "3 Michelin Stars"
        }
    }
    
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

enum Cuisine: String, Codable, CaseIterable, Identifiable {
    var id: String { return rawValue }
    
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
