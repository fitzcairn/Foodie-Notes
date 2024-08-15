//
//  ImagePickerView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/12/24.
//

import SwiftUI
import ExyteMediaPicker


struct SingleImagePickerButton: View {
    @Binding var picture: Picture?;
    var onSave:() -> Void = {}

    var body: some View {
        MultiImagePickerButton(
            pictures: Binding<[Picture]>(
                get: { [] },
                set: { if !$0.isEmpty { picture = $0[0] } }
            ),
            limit:1)
        .onChange(of: picture) {
            withAnimation {
                onSave()
            }
        }
    }
}

struct MultiImagePicker: View {
    @Binding var pictures:[Picture]
    @Binding var loadingCount:Int
    var limit:Int = Int.max // Get around bug in MediaPicker
    
    @StateObject private var photoPickerModel: PhotoPickerViewModel = PhotoPickerViewModel();
    @State private var isPickingPhoto: Bool = false;
    @State private var isLoading: Bool = false;
    @State private var newMedia: [Media] = [];
    @State private var newPictures: [Picture] = [];
    
    var body: some View {
        HStack {
            AddImageButton(loading:$isLoading) {
                isPickingPhoto = true;
            }
        }
        .onChange(of:isPickingPhoto) {
            isLoading = isPickingPhoto ? true : isLoading;
        }
        .onChange(of:newPictures) {
            withAnimation {
                pictures = pictures.filter() { !$0.deleted } + newPictures;
                newPictures = []
                loadingCount = 0
            }
        }
        .sheet(isPresented: $isPickingPhoto, onDismiss: {
            photoPickerModel.load(
                pickedMedia: newMedia,
                onLoaded: { photos in
                    newPictures = []
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
            .onAppear() {
                newMedia = []
            }
            .onDisappear() {
                loadingCount = newMedia.count
                Task {
                    await photoPickerModel.onStart()
                }
            }
        }
    }
}

struct MultiImagePickerButton: View {
    @Binding var pictures:[Picture]
    var icon:String = "\u{e913}"
    var limit:Int = Int.max // Get around bug in MediaPicker
    var onSave: () -> Void = {}

    @StateObject var photoPickerModel: PhotoPickerViewModel = PhotoPickerViewModel();
    @State private var isPickingPhoto: Bool = false;
    @State private var isLoading: Bool = false;
    @State private var newMedia: [Media] = [];
    @State private var newPictures: [Picture] = [];
    
    var body: some View {
        HStack {
            ZStack(alignment: .center) {
                if isLoading {
                    Loading(height:36)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                } else {
                    LargeActionWhiteButton(icon:icon) {
                        isPickingPhoto = true;
                    }
                }
            }
        }
        .frame(height:64)
        .onChange(of:isPickingPhoto) {
            isLoading = isPickingPhoto ? true : isLoading;
        }
        .onChange(of:newPictures) {
            pictures = pictures.filter() { !$0.deleted } + newPictures;
            newPictures = []
            onSave()
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
            .onDisappear() {
                Task {
                    await photoPickerModel.onStart()
                }
            }
        }
    }
}
