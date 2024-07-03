//
//  PictureSubViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import SwiftUI

// All views related to showing pictures and annotations
struct PictureSubViews {
    typealias PicturesAndNotes = AppModel.PicturesAndNotes
    typealias Picture = AppModel.Picture

    struct PictureAndNameView : View {
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
    
    struct PictureAndNameEditView : View {
        @Binding var name: String
        @Binding var picture: Picture
        
        var body: some View {
            HStack {
                EditablePictureView(picture:$picture)
                StyledTextField(inputText:$name)
                    .padding(.leading, 10)
                    .padding(.trailing, -10)
                Spacer()
            }
        }
    }

    struct PictureAndNotesViewSection: View {
        let title:String;
        let data:AppModel.PicturesAndNotes;
        
        var body: some View {
            Section(header: Text(title)) {
                HStack(alignment: .center) {
                    VStack(alignment: .center) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 64))], spacing:10) {
                            ForEach(data.pictures) { picture in
                                Image(systemName: picture.src)
                                    .resizable()
                                    .frame(width: 64.0, height: 64.0)
                            }
                        }
                    }
                    .padding(.leading, -10)

                    NotesSubViews.NotesView(inputText:data.notes)
                        .frame(maxWidth: .infinity)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
    
    struct PictureAndNotesEditSection: View {
        let title:String;
        @Binding var data:AppModel.PicturesAndNotes;
        
        var body: some View {
            Section(header: Text(title)) {
                HStack(alignment: .top) {
                    VStack(alignment: .center) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 64))], spacing:10) {
                            ForEach($data.pictures) { picture in
                                EditablePictureView(picture:picture)
                            }
                        }
                        
                        // Last picture is always an "add" button
                        // TODO: Add a camera AND album button, refactor buttons to MiscSubViews
                        Button(
                            action: {
                                // TODO: Implement
                                // data.pictures.append(Picture(NEW))
                                print("Add image -- via photo picker")
                            },
                            label: {
                                VStack {
                                    AddButtonImage()
                                }
                                .frame(width: 64, height: 64)
                            }
                        )
                        .padding(.trailing, 10)
                    }
                    StyledTextField(inputText:$data.notes)
                }
            }
        }
    }
    
    // A Picture that you can click and remove
    struct EditablePictureView : View {
        @Binding var picture:AppModel.Picture;
        
        var body: some View {
            ZStack(alignment: .top) {
                Image(systemName: picture.src)
                    .resizable()
                    .frame(width: 64.0, height: 64.0)
                HStack {
                    VStack(alignment: .leading) {
                        // Delete button for filled impages.
                        if (picture.state == .filled) {
                            Button(
                                action: {
                                    picture.state = .deleted
                                    print("Delete image!")
                                },
                                label: {
                                    ZStack {
                                        Image(systemName: "minus.circle.fill")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(Color.red)
                                        Image(systemName: "minus.circle")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(Color.white)
                                    }
                                }
                            )
                        }
                        // Edit button
                        Button(
                            action: {
                                // TODO: Implement photo picker
                                // data.pictures[i].src = NEW SRC
                                // data.pictures[i].state = .filled
                                print("Replace image -- via photo picker")
                            },
                            label: {
                                Image(systemName: "rectangle.2.swap")
                                    .resizable()
                                    .padding(4)
                                    .frame(width: 20, height: 20)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                                    .foregroundColor(.white)
                            }
                        )
                        .padding(.top, -5)
                        // New button
                        Button(
                            action: {
                                // TODO: Implement camera
                                // data.pictures[i].src = NEW SRC
                                // data.pictures[i].state = .filled
                                print("Replace image -- via camera")
                            },
                            label: {
                                Image(systemName: "camera.fill")
                                    .resizable()
                                    .padding(4)
                                    .frame(width: 20, height: 20)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                                    .foregroundColor(.white)
                            }
                        )
                        .padding(.top, -5)
                    }
                    Spacer()
                        .frame(width:30)
                }
            }
            .buttonStyle(.plain)
        }
    }
}
