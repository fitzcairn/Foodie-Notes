//
//  PictureSubViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import SwiftUI
import ExyteMediaPicker


// For all photos.
var photoWidth:CGFloat = 64;
var photoHeight:CGFloat = 64;

// All views related to showing pictures and annotations
struct PictureSubViews {

    struct NoPicturePlaceholderView: View {
        var body: some View {
            Image(systemName: "fork.knife.circle")
                .resizable()
                .padding(4)
                .frame(width:photoWidth, height: photoHeight)
                .background(Color.gray)
                .clipShape(Circle())
                .foregroundColor(.white)
                .opacity(0.5)
        }
    }
    
    struct PhotoView: View {
        let url:URL;
                
        var body: some View {
            GeometryReader { g in
                VStack {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                }
                .frame(width: g.size.width, height: g.size.height)
                .clipped()
            }
        }
    }
     
    // Actual picture
    struct PictureView : View {
        var picture: Picture?;
                
        var body: some View {
            if picture == nil || picture!.deleted {
                NoPicturePlaceholderView()
            }
            else if let url = picture!.url {
                PhotoView(url:url)
                    .aspectRatio(1, contentMode: .fill)
                    .frame(width:photoWidth, height: photoHeight)
            } else {
                NoPicturePlaceholderView()
            }
        }
    }
    
    // Show a picture, optionally with a delete.
    struct PictureEditView: View {
        @Binding var picture: Picture;
                
        var body: some View {
            ZStack(alignment: .top) {
                PictureView(picture:picture)
                VStack(alignment: .leading) {
                    Button(
                        action: {
                            picture.deleted = true
                        },
                        label: {
                            Image(systemName: "minus.circle.fill")
                                .resizable()
                                .padding(4)
                                .frame(width:20, height: 20)
                                .background(Color.red)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }
                    )
                    .buttonStyle(.plain)
                    Spacer()
                }
            }
        }
    }

    struct PhotoRollButton: View {
        @Binding var pictures:[Picture]
        var limit:Int = Int.max // Get around bug in MediaPicker

        @StateObject var photoPickerModel: PhotoPickerModel = PhotoPickerModel();

        @State private var isPickingPhoto: Bool = false;
        @State var newMedia: [Media] = [];
        
        var body: some View {
            Button(
                action: {
                    isPickingPhoto = true;
                },
                label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .padding(4)
                        .frame(width:photoWidth, height: photoHeight)
                        .background(Color.gray)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                        .opacity(0.5)
                }
            )
            .sheet(isPresented: $isPickingPhoto, onDismiss: {
                var newPictures:[Picture] = []
                
                photoPickerModel.load(
                    pickedMedia: newMedia,
                    onLoaded: { urls in
                        for url in urls {
                            newPictures.append(Picture(url:url));
                        }
                        pictures = pictures + newPictures;
                    })
                
            }) {
                MediaPicker(
                    isPresented: $isPickingPhoto,
                    onChange: {
                        if !$0.isEmpty { newMedia = $0 }
                    })
                .mediaSelectionLimit(limit)
                .mediaSelectionType(.photo)
                .showLiveCameraCell()
            }
            .task(id:photoPickerModel.hasNewPickedImages) {
                await photoPickerModel.onStart()
            }
        }
    }
    
    // Multi picture grid
    struct MultiPictureView: View {
        @Binding var pictures:[Picture]
        var edit:Bool = false;

        var body: some View {
            let columns = (edit && pictures.isEmpty) || (!edit && pictures.count == 1) ?
                [GridItem(.flexible(minimum: photoWidth))] :
                [GridItem(.flexible(minimum: photoWidth)), GridItem(.flexible(minimum: photoWidth))]

            VStack(alignment: .center) {
                LazyVGrid(columns: columns, spacing:10) {
                    ForEach(pictures.indices, id: \.self) { index in
                        if edit {
                            PictureEditView(picture:$pictures[index])
                        } else {
                            PictureView(picture:pictures[index])
                                .padding(.horizontal, -5)
                        }
                    }
                    if edit {
                        PhotoRollButton(pictures: $pictures)
                            .buttonStyle(.plain)
                    }
                }
            }
        }
    }
    
    struct PictureAndNotesEditSection: View {
        let title:String;
        @Binding var data:PicturesAndNotes;
        
        var body: some View {
            Section(header: Text(title)) {
                HStack(alignment: .top) {
                    MultiPictureView(
                        pictures:Binding<[Picture]>(
                            get: {
                                data.pictures
                            },
                            set: {
                                data.pictures = $0;
                            }),
                        edit:true)
                    .frame(width:data.pictures.isEmpty ? photoWidth : 2 * photoWidth)
                    .padding(.trailing, 5)
                    StyledTextField(inputText:$data.notes)
                    Spacer()
                }
            }
        }
    }
    
    struct PictureAndNotesViewSection: View {
        let title:String;
        let data:PicturesAndNotes;
        
        var body: some View {
            Section(header: Text(title)) {
                HStack(alignment: .top) {
                    if !data.pictures.isEmpty {
                        MultiPictureView(pictures:Binding(
                            get: { data.pictures },
                            set: { _ = $0 })
                        )
                        .frame(width:data.pictures.count <= 1 ? photoWidth : 2 * photoWidth)
                        .padding(.trailing, 5)
                    }
                    NotesSubViews.NotesView(inputText:data.notes)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
            }
        }
    }
    
    struct PictureAndNameEditView : View {
        @Binding var name: String
        @Binding var picture: Picture
        
        var body: some View {
            HStack {
                PictureView(picture:picture)
                StyledTextField(inputText:$name)
                    .padding(.leading, 10)
                    .padding(.trailing, -10)
                Spacer()
            }
        }
    }
    
    struct PictureAndNameView : View {
        let name: String
        let picture: Picture?
        
        var body: some View {
            HStack {
                PictureView(picture:picture)
                Text(name)
                    .padding(.leading, 10)
                Spacer()
            }
        }
    }
}
