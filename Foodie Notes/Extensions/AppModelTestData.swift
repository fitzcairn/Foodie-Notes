//
//  AppModelTestData.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/7/24.
//

import Foundation

// For testing only.
extension AppModel {
    // Populate some test data.
    mutating func addTestData(numTestMeals:Int) {
        for index in 0..<numTestMeals {
            self.index(
                Meal(
                    id: "m\(index)",
                    venue: Venue(name: "McDonalds", rating:4),
                    menu: PicturesAndNotes(
                        pictures: [
                        ],
                        notes: "An amazing menu populated by amazing deals!"),
                    courses: [
                        Course(id: "c1",
                               mealId: "m\(index)",
                               name: "Amuse Bouche",
                               date: Date(),
                               food: PicturesAndNotes(
                                pictures: [
                                ],
                                notes: "A delightful bite-sized explosion of flavors that sets the perfect tone for the culinary journey ahead."),
                               beveragePairing: PicturesAndNotes()
                              ),
                        Course(id: "c2",
                               mealId: "m\(index)",
                               name: "Lobster",
                               date: Date(),
                               food: PicturesAndNotes(
                                pictures: [
                                ],
                                notes: "A succulent lobster dish that boasts tender, buttery meat perfectly complemented by a rich, flavorful sauce."),
                               beveragePairing:PicturesAndNotes()
                              ),
                        Course(id: "c3",
                               mealId: "m\(index)",
                               name: "Veal",
                               date: Date(),
                               food: PicturesAndNotes(
                                pictures: [
                                ],
                                notes: "A tender veal dish with a delicate balance of flavors, offering a melt-in-your-mouth experience."),
                               beveragePairing: PicturesAndNotes(
                                pictures: [
                                ],
                                notes: "A masterful wine pairing that elevates each dish, enhancing flavors and creating a harmonious dining experience.")
                              ),
                        Course(id: "c4",
                               mealId: "m\(index)",
                               name: "Amuse Bouche",
                               date: Date(),
                               food: PicturesAndNotes(
                                pictures: [
                                    Picture(),
                                ],
                                notes: "Chocolate for days!"),
                               beveragePairing:PicturesAndNotes()
                              ),
                    ],
                    date: Date(),
                    notes: "A lovely meal with amazingly mature cheese on the Big Mac."
                )
            )
        }
    }
}

