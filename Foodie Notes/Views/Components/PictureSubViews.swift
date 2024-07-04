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
    typealias PicturesAndNotes = AppModel.PicturesAndNotes
    typealias Picture = AppModel.Picture

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

    // Actual picture
    struct PictureView : View {
        var picture: Picture?;
                
        var body: some View {
            if picture == nil || picture!.deleted {
                return NoPicturePlaceholderView()
            }
            if let media = picture!.src {
                PhotoView(viewModel: PhotoViewModel(media: media))
                    .aspectRatio(1, contentMode: .fill)
            } else {
                Image(systemName: "hourglass.circle")
                    .resizable()
                    .padding(4)
                    .frame(width:photoWidth, height: photoHeight)
                    .background(Color.gray)
                    .clipShape(Circle())
                    .foregroundColor(.white)
                    .opacity(0.5)
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
    
    struct CameraButton: View {
        @Binding var picture:Picture;
        @State private var isTakingLivePhoto:Bool = false;
        
        var body: some View {
            Button(
                action: {
                    isTakingLivePhoto = true;
                },
                label: {
                    Image(systemName: "camera.circle")
                        .resizable()
                        .padding(4)
                        .frame(width:24, height: 24)
                        .background(Color.gray)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }
            )
            .sheet(isPresented: $isTakingLivePhoto) {
                MediaPicker(
                    isPresented: $isTakingLivePhoto,
                    onChange: {
                        picture.src = $0.first
                    })
                .mediaSelectionLimit(1)
                .mediaSelectionType(.photo)
            }
        }
    }

    struct PhotoRollButton: View {
        @Binding var picture:Picture;
        var limit:Int = Int.max // Get around bug in MediaPicker

        @State private var ispickingPhoto:Bool = false;
        
        var body: some View {
            Button(
                action: {
                    ispickingPhoto = true;
                },
                label: {
                    Image(systemName: "photo.circle")
                        .resizable()
                        .padding(4)
                        .frame(width:24, height: 24)
                        .background(Color.gray)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }
            )
            .sheet(isPresented: $ispickingPhoto) {
                MediaPicker(
                    isPresented: $ispickingPhoto,
                    onChange: {
                        picture.src = $0.first
                    })
                .mediaSelectionLimit(limit)
                .mediaSelectionType(.photo)
            }
        }
    }

    struct SinglePictureEdit: View {
        @Binding var picture:Picture;

        var body: some View {
            VStack {
                PictureEditView(picture:$picture)
                Spacer()
                    .frame(height:20)
                HStack {
                    CameraButton(picture: $picture)
                    PhotoRollButton(picture: $picture, limit:1)
                }
            }
        }
    }
    
    // Multi picture grid
    struct MultiPictureView: View {
        @Binding var pictures:[Picture]
        var edit:Bool = false;

        var body: some View {
            VStack(alignment: .center) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 64))], spacing:10) {
                    ForEach(pictures.indices, id: \.self) { index in
                        if edit {
                            PictureView(picture:pictures[index])
                        } else {
                            PictureEditView(picture:$pictures[index])
                        }
                    }
                }
                if edit {
                    Spacer()
                        .frame(height:20)
                    HStack {
                        var newPicture = Binding<Picture>(
                            get: { Picture() },
                            set: { pictures.append($0) })
                        CameraButton(picture:newPicture)
                        PhotoRollButton(picture: newPicture)
                    }
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
                    MultiPictureView(pictures:$data.pictures, edit:true)
                    StyledTextField(inputText:$data.notes)
                    Spacer()
                }
            }
        }
    }
    
    struct PictureAndNotesViewSection: View {
        let title:String;
        let data:AppModel.PicturesAndNotes;
        
        var body: some View {
            Section(header: Text(title)) {
                HStack(alignment: .top) {
                    MultiPictureView(pictures:Binding(
                        get: { data.pictures },
                        set: { _ = $0 })
                    )
                    NotesSubViews.NotesView(inputText:data.notes)
                        .frame(maxWidth: .infinity)
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
                PictureEditView(picture:$picture)
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
