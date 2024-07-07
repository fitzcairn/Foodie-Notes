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
                .frame(width:Constant.photoWidth, height: Constant.photoHeight)
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
    struct PhotoShowView : View {
        var picture: Picture?;
        
        var body: some View {
            if picture == nil || picture!.deleted {
                NoPhotoPlaceholderView()
            }
            else if let url = picture!.url {
                PhotoView(url:url)
                    .aspectRatio(1, contentMode: .fill)
                    .frame(width:Constant.photoWidth, height: Constant.photoHeight)
            } else {
                NoPhotoPlaceholderView()
            }
        }
    }
    
    // Show a picture with a delete.
    struct PhotoEditView: View {
        @Binding var picture: Picture;
        
        var body: some View {
            ZStack(alignment: .top) {
                PhotoShowView(picture:picture)
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
                        .frame(width:Constant.photoWidth, height: Constant.photoHeight)
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
}
