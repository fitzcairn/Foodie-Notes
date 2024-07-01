//
//  CoursesViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import SwiftUI

// All views and logic related to courses.
struct CoursesViews {
    private static var missingImage = "fork.knife.circle";
    
    // TODO: replace with view model
    struct Course : Hashable, Equatable {
        static func == (lhs: CoursesViews.Course, rhs: CoursesViews.Course) -> Bool {
            return lhs.name == rhs.name
        }
        func hash(into hasher: inout Hasher) {
          hasher.combine(name)
        }
        
        let name:String
        let pickedImage:String?
        let food:PictureViews.PicturesAndNotes
        let wine:PictureViews.PicturesAndNotes?
        let date:Date
        // TODO: Add meal, venue, date, id
        
    }
    
    // TODO: Move this to a test case.
    public static var testCourses = [
        Course(
            name: "Amuse Bouche",
            pickedImage: "gearshape",
            food: PictureViews.PicturesAndNotes(
                pictures: [
                    "star.leadinghalf.filled",
                    "gearshape",
                    "figure.walk"
                ],
                notes: "A delightful bite-sized explosion of flavors that sets the perfect tone for the culinary journey ahead."
            ),
            wine: nil,
            date: Date()
        ),
        Course(
            name: "Lobster",
            pickedImage: nil,
            food: PictureViews.PicturesAndNotes(
                pictures: [
                    "flame.fill",
                ],
                notes: "A succulent lobster dish that boasts tender, buttery meat perfectly complemented by a rich, flavorful sauce."
                ),
            wine: PictureViews.PicturesAndNotes(
                pictures: [
                    "circle.square.fill",
                    "keyboard",
                    "gearshape"
                ],
                notes: "A masterful wine pairing that elevates each dish, enhancing flavors and creating a harmonious dining experience."
            ),
            date: Date()
        ),
        Course(
            name: "Veal",
            pickedImage: nil,
            food: PictureViews.PicturesAndNotes(
                pictures: [
                    "moon.stars.fill",
                    "leaf.arrow.circlepath",
                    "gearshape"
                ],
                notes: "A tender veal dish with a delicate balance of flavors, offering a melt-in-your-mouth experience."
                ),
            wine: PictureViews.PicturesAndNotes(
                pictures: [
                    "airplane.departure",
                ],
                notes: "A masterful wine pairing that elevates each dish, enhancing flavors and creating a harmonious dining experience."
            ),
            date: Date()
        ),
        Course(
            name: "Dessert",
            pickedImage: "airplane.departure",
            food: PictureViews.PicturesAndNotes(
                pictures: [
                    "star.fill",
                    "rectangle.on.rectangle.circle",
                    "music.note"
                ],
                notes: "A delightful bite-sized explosion of flavors that sets the perfect tone for the culinary journey ahead."
                ),
            wine: PictureViews.PicturesAndNotes(
                pictures: [
                    "cart.circle",
                    "airplane.departure"
                ],
                notes: "A masterful wine pairing that elevates each dish, enhancing flavors and creating a harmonious dining experience."
            ),
            date: Date()
        )
    ]
    
    
    struct CoursesViewSection : View {
        // TODO: replace with view model
        @State private var courses = testCourses;
        
        var body: some View {
            Section(header: Text("Courses")) {
                List {
                    ForEach(courses, id: \.self) { course in
                        CourseItemView(course)
                    }
                }
            }
        }
    }
    
    struct CoursesEditSection : View {
        // TODO: replace with view model
        @State private var courses = testCourses;
        
        var body: some View {
            Section(header: header) {
                List {
                    ForEach(courses, id: \.self) { course in
                        CourseItemView(course)
                    }
                    .onDelete(perform: remove)
                }
            }
        }
        
        var header: some View {
            HStack {
                Text("Courses")
                Spacer()
                NavigationLink(destination: CourseCreateOrEditView()) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.black)
                        .padding(.trailing, -20)
                }
            }
        }
        
        func remove(at offsets: IndexSet) {
            // TODO: Implement delete
        }
    }
        
    struct CourseNameAndPickedImageView : View {
        private let course:Course
        
        init(_ input:Course) {
            course = input;
        }
        
        var body: some View {
            NameViews.NameAndImageView(name:course.name,
                                       image:getPickedImage(from: course.pickedImage))
        }
    
        func getPickedImage(from image:String?) -> String {
            if let preferred = image {
                return preferred
            }
            return missingImage
        }
    }
    
    // Individual course in a list
    struct CourseItemView : View {
        private let course:Course
        
        init(_ input:Course) {
            course = input;
        }
        
        var body: some View {
            HStack {
                Image(systemName: getImage(from: course.pickedImage, in: course.food.pictures))
                    .resizable()
                    .frame(width: 64.0, height: 64.0)
                // TODO: implement passing in the course for edit, or nil for create.
                NavigationLink(destination: CourseCreateOrEditView()) {
                    VStack(alignment: .leading) {
                        Text(course.name)
                            .bold()
                        Text(course.food.notes)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(8)
                }
            }
        }
        
        // TODO: Move to view model
        func getImage(from image:String?, in images:[String]) -> String {
            if let preferred = image {
                return preferred
            }
            return images.isEmpty ? missingImage : images.randomElement() ?? missingImage;
        }
        
    }
    
}
