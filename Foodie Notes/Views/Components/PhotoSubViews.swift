//
//  PhotoSubViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/7/24.
//

import SwiftUI
import ExyteMediaPicker


struct PhotoSubViews {
    struct NoPhotoPlaceholderView: View {
        var body: some View {
            Image(systemName: "fork.knife.circle")
                .resizable()
                .padding(4)
                .frame(width:PhotoDimensions.photoWidth, height: PhotoDimensions.photoHeight)
                .background(Color.gray)
                .clipShape(Circle())
                .foregroundColor(.white)
                .opacity(0.5)
        }
    }
    
    struct PhotoView: View {
        @StateObject var photoModel:AsyncPhotoViewModel = AsyncPhotoViewModel()
        let img: SavedImage;

        var body: some View {
            GeometryReader { g in
                VStack {
                    AsyncPhotoView(
                        source: photoModel,
                        img: img,
                        progressContent: {
                            ProgressView()
                                .frame(width: 18, height: 18)
                        },
                        photoContent: {
                            let image = UIImage(data: photoModel.loadedImg?.imgData ?? Data()) ?? UIImage()
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                        }
                    )
                }
                .frame(width: g.size.width, height: g.size.height)
                .clipped()
            }
        }
    }
    
    
    /*struct PhotoView: View {
        let picture:Picture
        var showFull:Bool = false;
        
        var body: some View {
            GeometryReader { g in
                VStack {
                    if let data = picture.data {
                        let image: UIImage = UIImage(data: data) ?? UIImage()
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    }
                }
                .frame(width: g.size.width, height: g.size.height)
                .clipped()
            }
        }
    }*/
    
    // Photo expand
    struct PhotoExpandView : View {
        @Environment(\.dismiss) var dismiss
        let picture:Picture
        @Binding var sheetShowing:Bool;
        
        var body: some View {
            if let full = picture.photo?.full {
                PhotoView(img:full)
                    .background(.black)
                    .onTapGesture {
                        sheetShowing = false;
                    }
            } else {
                EmptyView()
            }
        }
    }
    
    // Actual picture
    struct PhotoShowView : View {
        var picture: Picture?;
        var isEditMode:Bool = false
        @State var sheetShowing:Bool = false;
        
        var body: some View {
            if picture == nil || picture!.deleted  {
                NoPhotoPlaceholderView()
            }
            else if picture?.photo != nil {
                if (!isEditMode) {
                    // Only allow on-tap expands if not editing.
                    PhotoView(img:picture!.photo!.thumb)
                        .aspectRatio(1, contentMode: .fill)
                        .frame(width:PhotoDimensions.photoWidth, height: PhotoDimensions.photoHeight)
                        .onTapGesture {
                            sheetShowing = true;
                        }
                        .sheet(isPresented: $sheetShowing) {
                            PhotoExpandView(picture:picture!, sheetShowing: $sheetShowing)
                        }
                } else {
                    PhotoView(img:picture!.photo!.thumb)
                        .aspectRatio(1, contentMode: .fill)
                        .frame(width:PhotoDimensions.photoWidth, height: PhotoDimensions.photoHeight)
                }
            } else {
                NoPhotoPlaceholderView()
            }
        }
    }
    
    // Show a picture with a delete.
    struct PhotoEditView: View {
        @Binding var picture: Picture?;
        
        var body: some View {
            ZStack(alignment: .center) {
                if (picture == nil || picture!.deleted) {
                    PhotoPickerButton(
                        pictures: Binding<[Picture]>(
                            get: { [] },
                            set: { if !$0.isEmpty { picture = $0[0] } }
                        ),
                        limit:1)
                } else {
                    PhotoShowView(picture:picture, isEditMode:true)
                    VStack(alignment: .leading) {
                        Button(
                            action: {
                                picture!.deleted = true
                            },
                            label: {
                                Image(systemName: "minus.circle.fill")
                                    .resizable()
                                    .padding(4)
                                    .frame(width:PhotoDimensions.photoWidth * 0.8, height: PhotoDimensions.photoWidth * 0.8)
                                    .background(Color.gray)
                                    .clipShape(Circle())
                                    .foregroundColor(.white)
                            }
                        )
                        .opacity(0.5)
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
    
    struct PhotoPickerButton: View {
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
                        .frame(width:PhotoDimensions.photoWidth, height: PhotoDimensions.photoHeight)
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
                    onLoaded: { photos in
                        for photo in photos {
                            newPictures.append(Picture(photo:photo))
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
}
