//
//  PictureViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import SwiftUI

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
