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
    
    // Photo expand
    struct PhotoExpandView : View {
        @Environment(\.dismiss) var dismiss
        let url:URL
        @Binding var sheetShowing:Bool;
        
        var body: some View {
            PhotoView(url:url)
                .background(.black)
                .onTapGesture {
                    sheetShowing = false;
                }
        }
    }
    
    // Actual picture
    struct PhotoShowView : View {
        var picture: Picture?;
        var isEditMode:Bool = false
        @State var sheetShowing:Bool = false;
        
        var body: some View {
            if picture == nil || picture!.deleted {
                NoPhotoPlaceholderView()
            }
            else if let url = picture!.url {
                if (!isEditMode) {
                    // Only allow on-tap expands if not editing.
                    PhotoView(url:url)
                        .aspectRatio(1, contentMode: .fill)
                        .frame(width:Constant.photoWidth, height: Constant.photoHeight)
                        .onTapGesture {
                            sheetShowing = true;
                        }
                        .sheet(isPresented: $sheetShowing) {
                            PhotoExpandView(url:url, sheetShowing: $sheetShowing)
                        }
                } else {
                    PhotoView(url:url)
                        .aspectRatio(1, contentMode: .fill)
                        .frame(width:Constant.photoWidth, height: Constant.photoHeight)
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
                                    .frame(width:Constant.photoWidth * 0.8, height: Constant.photoWidth * 0.8)
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
