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
                EditablePictureView(picture: picture,
                                    deleteAction: {
                                        picture.state = .deleted;
                                    },
                                    editAction: {
                                        // TODO: Implement photo picker
                                        // picture.src = NEW SRC
                                        // picture.state = .filled
                                        print("Replace image -- via photo picker")
                                    },
                                    newAction: {
                                        // TODO: Implement camera
                                        // picture.src = NEW SRC
                                        // picture.state = .filled
                                        print("Replace image -- via camera")
                                    })
                NameSubViews.NameEditView(name:$name)
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
                HStack(alignment: .center) {
                    VStack(alignment: .center) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 64))], spacing:10) {
                            ForEach($data.pictures.indices) { i in
                                EditablePictureView(picture:data.pictures[i],
                                                    deleteAction: {
                                                        data.pictures[i].state = .deleted;
                                                    },
                                                    editAction: {
                                                        // TODO: Implement photo picker
                                                        // data.pictures[i].src = NEW SRC
                                                        // data.pictures[i].state = .filled
                                                        print("Replace image -- via photo picker")
                                                    },
                                                    newAction: {
                                                        // TODO: Implement camera
                                                        // data.pictures[i].src = NEW SRC
                                                        // data.pictures[i].state = .filled
                                                        print("Replace image -- via camera")
                                                    }
                                )
                            }
                        }
                        // Last picture is always an "add" button
                        Button(
                            action: {
                                // TODO: Implement
                                // data.pictures.append(Picture(NEW))
                                print("Add image -- via photo picker")
                            },
                            label: {
                                VStack {
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.black)
                                }
                                .frame(width: 64, height: 64)
                            }
                        )
                        .padding(.trailing, 10)
                    }
                    NotesSubViews.NotesEditView(inputText:$data.notes)
                }
            }
        }
    }
    
    // A Picture that you can click and remove
    struct EditablePictureView : View {
        // No binding needed -- changes to state are handled in callbacks.
        let picture:AppModel.Picture;
        let deleteAction: (() -> Void)
        let editAction: (() -> Void)
        let newAction: (() -> Void)
        
        var body: some View {
            ZStack(alignment: .top) {
                Image(systemName: picture.src)
                    .resizable()
                    .frame(width: 64.0, height: 64.0)
                HStack {
                    // Delete button
                    Button(
                        action: deleteAction,
                        label: {
                            ZStack {
                                Image(systemName: "minus.circle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(Color.red)
                                Image(systemName: "x.circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(Color.white)
                            }
                        }
                    )
                    // Edit button
                    Button(
                        action: editAction,
                        label: {
                            Image(systemName: "rectangle.2.swap")
                                .resizable()
                                .padding(6)
                                .frame(width: 24, height: 24)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }
                    )
                    // New button
                    Button(
                        action: newAction,
                        label: {
                            Image(systemName: "camera.fill")
                                .resizable()
                                .padding(6)
                                .frame(width: 24, height: 24)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }
                    )

                }
                Spacer()
                    .frame(width: 40)
            }
            .padding(.trailing, 10)
        }
    }
}
