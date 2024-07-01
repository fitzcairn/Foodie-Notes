//
//  ComponentViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/30/24.
//

import SwiftUI


struct SaveButton: View {
    var body: some View {
        Button(
            action: {
                // TODO: trigger model write.
                print("Save tapped")
            },
            label: {
                Text("Save")
                    .frame(minWidth: 0, maxWidth: 200)
                    .font(.system(size: 18))
                    .padding()
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white, lineWidth: 2)
                    )
            })
            .background(Color.blue)
            .cornerRadius(25)
    }
}


//  All views related to notes.
struct NotesViews {
    // Display a note in a section
    struct NotesSection: View {
        let title: String;
        let note: String;

        var body: some View {
            Section(header: Text(title)) {
                NotesView(note:note)
            }
        }
    }


    // Display a note
    struct NotesView: View {
        let note: String;
        
        var body: some View {
            Text(note);
        }
    }

    // Notes edit embedded in a standalone session
    struct NotesEditSection: View {
        let title:String;

        var body: some View {
            Section(header: Text(title)) {
                NotesEditView()
            }
        }
    }
    
    // Notes edit view
    struct NotesEditView: View {
        @State var inputText:String = ""

        var body: some View {
            ZStack {
                if inputText.isEmpty {
                    HStack {
                        Text("Tap to Add Note")
                            .opacity(0.2)
                            .padding(.horizontal, 15)
                        Spacer()
                    }
                }
                HStack(alignment: .top) {
                    TextEditor(text: $inputText)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 6)
                    Spacer()
                    Button(
                        action: {
                            self.inputText = ""
                        },
                        label: {
                            Image(systemName: "x.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Color.gray)
                        }
                    )
                    .padding(.trailing, 4)
                    .padding(.top, 6)
                }
                .buttonStyle(.plain)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
            .padding(.horizontal, -15)
        }
    }
}



// All views related to showing and editing dates.
struct DateViews {
    private static let title:String = "When Enjoyed"
    private static let prompt:String = "Date/Time:"

    
    struct DatePickerSection: View {
        @State var selectedDate: Date = Date()
        
        var body: some View {
            Section(title) {
                DatePicker(
                    prompt,
                    selection: $selectedDate,
                    in: ...Date(),
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.compact)
                .bold()
            }
        }
    }
    
    struct DateSection: View {
        let date: Date;
        let dateFormatter: DateFormatter;
        
        init(_ date: Date) {
            self.date = date
            self.dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
        }
                
        var body: some View {
            Section(title) {
                HStack {
                    Text(dateFormatter.string(from: date))
                }
            }
        }
    }
}

// All views related to showing pictures and annotations
struct PictureViews {
    // TODO: replace with view model
    struct PicturesAndNotes : Hashable {
        let pictures:[String]
        let notes:String
    }

    struct PictureAndNotesViewSection: View {
        let title:String;
        // TODO: Comes from view model.
        let data:PicturesAndNotes;
        
        var body: some View {
            Section(header: Text(title)) {
                HStack(alignment: .center) {
                    VStack(alignment: .center) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 64))], spacing:10) {
                            ForEach(data.pictures, id:\.self) { imgStr in
                                Image(systemName: imgStr)
                                    .resizable()
                                    .frame(width: 64.0, height: 64.0)
                            }
                        }
                    }
                    NotesViews.NotesView(note:data.notes)
                        .frame(maxWidth: .infinity)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
    
    struct PictureAndNotesEditSection: View {
        let title:String;
        // TODO: Comes from view model.
        var data:PicturesAndNotes? = nil;
        
        var body: some View {
            Section(header: Text(title)) {
                HStack(alignment: .center) {
                    VStack(alignment: .center) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 64))], spacing:10) {
                            ForEach(data?.pictures ?? [], id:\.self) { imgStr in
                                EditablePictureView(image: imgStr, deleteAction:deletePhoto)
                            }
                            EditablePictureView()
                        }
                    }
                    NotesViews.NotesEditView(inputText:data?.notes ?? "")
                        //.frame(maxWidth: .infinity)
                        //.fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        
        // TODO: Implement
        private func deletePhoto() {
            print("DELETE photo!!")
        }
    }
    
    // A Picture that you can click and remove
    struct EditablePictureView: View {
        // TODO: tie to actual view model.
        var image: String? = nil;
        
        // Allow this to also delete.
        var deleteAction: (() -> Void)? = nil;
        
        var body: some View {
            ZStack(alignment: .top) {
                if let picture = image {
                    Image(systemName: picture)
                        .resizable()
                        .frame(width: 64.0, height: 64.0)
                    HStack {
                        Button(
                            action: deleteAction ?? pickPhoto,
                            label: {
                                if let action = deleteAction {
                                    ZStack {
                                        Image(systemName: "x.circle.fill")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(Color.red)
                                        Image(systemName: "x.circle")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(Color.white)
                                    }
                                } else {
                                    Image(systemName: "pencil")
                                        .resizable()
                                        .padding(6)
                                        .frame(width: 24, height: 24)
                                        .background(Color.blue)
                                        .clipShape(Circle())
                                        .foregroundColor(.white)
                                }
                            }
                        )
                        Spacer()
                            .frame(width: 40)
                    }
                } else {
                    Button(
                        action: pickPhoto,
                        label: {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.black)
                        }
                    )
                }
            }
            .padding(.trailing, 10)
        }

        // TODO: Implement
        private func pickPhoto() {
            print("Pop photo picker!!")
        }

    }
}

// Name of something
struct NameViews {
    private static let title:String = "Name"

    struct NameAndImageView : View {
        private let name:String
        private let image:String
        
        init(name: String, image: String) {
            self.name = name
            self.image = image
        }
        
        var body: some View {
            HStack {
                Image(systemName: image)
                    .resizable()
                    .frame(width: 64.0, height: 64.0)
                Text(name)
                    .padding(.leading, 10)
                Spacer()
            }
        }
    }
    
    struct NameAndImageEditView : View {
        // TODO: Needs to be in viewmodel.
        @Binding var name: String
        // TODO: Needs to be in viewmodel.
        @Binding var image: String?
        
        var body: some View {
            HStack {
                PictureViews.EditablePictureView(image: image)
                NameEditView(name:$name)
                Spacer()
            }
        }
    }
    
    struct NameViewSection : View {
        // TODO: Needs to be in viewmodel.
        let name:String;
        
        var body: some View {
            Section(header: Text(title)) {
                HStack {
                    Text(name)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                }
            }
        }
    }

    struct NameEditSection : View {
        // TODO: Needs to be in viewmodel.
        @Binding var name: String
        
        var body: some View {
            Section(header: Text(title)) {
                HStack {
                    NameEditView(name: $name)
                }
            }
        }
    }
    
    struct NameEditView : View {
        // TODO: Needs to be in viewmodel.
        @Binding var name: String
        
        var body: some View {
            HStack(alignment: .top) {
                TextField("", text: $name, prompt: Text("Tap to Add"))
                    .padding(.horizontal, 4)
                    .padding(.vertical, 6)
                Spacer()
                Button(
                    action: {
                        self.name = ""
                    },
                    label: {
                        Image(systemName: "x.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color.gray)
                    }
                )
                .padding(.trailing, 4)
                .padding(.top, 6)
            }
            .buttonStyle(.plain)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
    }
}


// All views and logic related to Location
struct LocationViews {
    private static let title:String = "Venue and Rating"

    struct LocationViewSection : View {
        let venue:String;
        let rating:Int;
        
        var body: some View {
            Section(header: Text(title)) {
                HStack {
                    Text(venue)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    Spacer() 
                    RatingViews.RatingView(rating: rating)
                }
            }
        }
    }

    struct LocationEditSection : View {
        // TODO: Needs to be in viewmodel.
        @Binding var venue: String
        
        var body: some View {
            Section(header: Text(title)) {
                HStack {
                    NameViews.NameEditView(name:$venue)
                    Spacer()
                    RatingViews.RatingEditView(rating:.constant(0))
                }
            }
        }
    }
}

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


//  All views and logic related to rating.
struct RatingViews {
    // TODO: move to model
    private static let maximumRating = 5
    
    private static let offImage = Image(systemName: "star")
    private static let onImage = Image(systemName: "star.fill")

    private static let offColor = Color.gray
    private static let onColor = Color.orange
    
    private static func image(for number: Int, score: Int) -> Image {
        if number > score {
            offImage
        } else {
            onImage
        }
    }
        
    struct RatingView : View {
        // TODO: Needs to be in viewmodel.
        let rating:Int;
               
        var body: some View {
            HStack {
                ForEach(1..<maximumRating + 1, id: \.self) { number in
                    image(for: number, score:rating)
                        .foregroundColor(number > rating ? offColor : onColor)
                }
            }
        }
    }
    
    struct RatingEditView : View {
        // TODO: Needs to be in viewmodel.
        @Binding var rating: Int
               
        var body: some View {
            HStack {
                ForEach(1..<maximumRating + 1, id: \.self) { number in
                    Button(
                        action: {
                            rating = number
                            print(number)
                        }, label: {
                            image(for: number, score:rating)
                                .foregroundColor(number > rating ? offColor : onColor)
                        }
                    )
                }
            }
            .buttonStyle(.plain)
        }
    }

}
