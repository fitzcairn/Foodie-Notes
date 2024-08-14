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
            onSave()
        }
    }
}

struct MultiImagePicker<Content: View>: View {
    @Binding var pictures:[Picture]
    var limit:Int = Int.max // Get around bug in MediaPicker
    let content: Content;
    
    @StateObject private var photoPickerModel: PhotoPickerViewModel = PhotoPickerViewModel();
    @State private var isPickingPhoto: Bool = false;
    @State private var isLoading: Bool = false;
    @State private var newMedia: [Media] = [];
    @State private var newPictures: [Picture] = [];
    
    init(pictures: Binding<[Picture]>, limit: Int, @ViewBuilder _ content: () -> Content) {
        self._pictures = pictures
        self.limit = limit
        self.content = content()
    }
    
    var body: some View {
        HStack {
            if isLoading {
                Loading(height:36)
            } else {
                content
                    .onTapGesture {
                        isPickingPhoto = true;
                    }
            }
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

struct MultiImagePickerButton: View {
    @Binding var pictures:[Picture]
    var icon:String = "\u{e913}"
    var limit:Int = Int.max // Get around bug in MediaPicker

    @StateObject var photoPickerModel: PhotoPickerViewModel = PhotoPickerViewModel();
    @State private var isPickingPhoto: Bool = false;
    @State private var isLoading: Bool = false;
    @State private var newMedia: [Media] = [];
    @State private var newPictures: [Picture] = [];
    
    var body: some View {
        HStack {
            if isLoading {
                Loading(height:36)
            } else {
                LargeActionWhiteButton(icon:icon) {
                    isPickingPhoto = true;
                }

            }
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
