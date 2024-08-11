//
//  PhotoSubViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/7/24.
//

import SwiftUI
import ExyteMediaPicker


// Expandable clipped image for a variable height row
struct VariableHeightListPicture : View {
    var picture: Picture?;
    
    var body: some View {
        PictureView(picture: picture)
            .frame(minWidth:56, maxWidth:56, minHeight: 56, maxHeight: .infinity)
    }
}


// Clipped image for a cover
struct CoverPicture : View {
    var picture: Picture?;
    
    var body: some View {
        PictureView(picture: picture, useThumb: false)
            .frame(height:270)
            .clipped()
    }
}

// Clipped image for meal list.
struct MealListPicture : View {
    var picture: Picture?;

    var body: some View {
        PictureView(picture: picture)
            .frame(width:64, height:113)
            .clipped()
    }
}

private struct NoPhotoPlaceholderView: View {
    var body: some View {
        Image(.noPhoto)
            .resizable()
            .scaledToFill()
            .aspectRatio(contentMode: .fill)
    }
}

private struct PhotoView: View {
    @StateObject var photoModel:AsyncPhotoViewModel = AsyncPhotoViewModel()
    let img: SavedImage;

    var body: some View {
        AsyncPhotoView(
            source: photoModel,
            img: img,
            progressContent: {
                ProgressView()
            },
            photoContent: {
                let image = UIImage(data: photoModel.loadedImg?.imgData ?? Data()) ?? UIImage()
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: .fill)
            }
        )
    }
}

private struct PictureView : View {
    var picture: Picture?;
    var useThumb: Bool = true;
    
    var body: some View {
        HStack {
            if picture == nil || picture!.deleted || picture?.photo == nil  {
                NoPhotoPlaceholderView()
            }
            else {
                PhotoView(img: useThumb ? picture!.photo!.thumb : picture!.photo!.full)
            }
        }
    }
}







struct PhotoSubViews {
    struct NoPhotoPlaceholderView: View {
        var body: some View {
            Image(systemName: "fork.knife.circle")
                .resizable()
                .padding(4)
                .frame(width:PhotoDimensions.photoThumbWidth, height: PhotoDimensions.photoThumbHeight)
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
                            Loading()
                        },
                        photoContent: {
                            let image = UIImage(data: photoModel.loadedImg?.imgData ?? Data()) ?? UIImage()
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .aspectRatio(1, contentMode: .fit)
                        }
                    )
                }
                .frame(width: g.size.width, height: g.size.height)
                .clipped()
            }
        }
    }
    
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
                        .frame(width:PhotoDimensions.photoThumbWidth, height: PhotoDimensions.photoThumbHeight)
                        .onTapGesture {
                            sheetShowing = true;
                        }
                        .sheet(isPresented: $sheetShowing) {
                            PhotoExpandView(picture:picture!, sheetShowing: $sheetShowing)
                        }
                } else {
                    PhotoView(img:picture!.photo!.thumb)
                        .aspectRatio(1, contentMode: .fill)
                        .frame(width:PhotoDimensions.photoThumbWidth, height: PhotoDimensions.photoThumbHeight)
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
                                    .frame(width:PhotoDimensions.photoThumbWidth * 0.8, height: PhotoDimensions.photoThumbWidth * 0.8)
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
    
    private struct Loading: View {
        var body: some View {
            HStack {
                ProgressView()
                    .frame(width:PhotoDimensions.photoThumbWidth, height: PhotoDimensions.photoThumbHeight)
            }
        }
    }
    
    struct PhotoPickerButton: View {
        @Binding var pictures:[Picture]
        var limit:Int = Int.max // Get around bug in MediaPicker

        @StateObject var photoPickerModel: PhotoPickerViewModel = PhotoPickerViewModel();
        @State private var isPickingPhoto: Bool = false;
        @State private var isLoading: Bool = false;
        @State private var newMedia: [Media] = [];
        @State private var newPictures: [Picture] = [];
        
        var body: some View {
            HStack {
                Button(
                    action: {
                        isPickingPhoto = true;
                    },
                    label: {
                        if isLoading {
                            Loading()
                        } else {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .padding(4)
                                .background(Color.gray)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                                .opacity(0.5)
                        }
                    }
                )
                .disabled(isLoading || isPickingPhoto)
                .frame(width:PhotoDimensions.photoThumbWidth, height: PhotoDimensions.photoThumbHeight)
            }
            .onChange(of:isPickingPhoto) {
                isLoading = isPickingPhoto ? true : isLoading;
            }
            .onChange(of:newPictures) {
                pictures = pictures.filter() { !$0.deleted } + newPictures;
                newPictures = []
            }
            .sheet(isPresented: $isPickingPhoto, onDismiss: {
                photoPickerModel.load(
                    pickedMedia: newMedia,
                    onLoaded: { photos in
                        for photo in photos {
                            newPictures.append(Picture(photo:photo))
                        }
                        isLoading = false;
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
                .onDisappear() {
                    Task {
                        await photoPickerModel.onStart()
                    }
                }
            }
        }
    }
}
