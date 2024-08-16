//
//  ImagePickerView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/12/24.
//

import SwiftUI
import ExyteMediaPicker


struct CoverImageAndPickerView: View {
    @EnvironmentObject var viewModel:AppViewModel;

    @Binding var picture: Picture?;
    var onSave:() -> Void = {}
    
    @State var isLoading:Bool = false;
    @State var isPickingPhoto: Bool = false;
    @State var loadingCount:Int = 0;
    
    var body: some View {
        ZStack(alignment: .top) {
            if (isLoading && viewModel.isPictureEmpty(picture)) {
                ImageLoadingView()
                    .frame(height:270)
            } else if (isLoading) {
                ImageLoadingBorder {
                    CoverPicture(picture: picture)
                        .id(picture)
                }
            } else {
                CoverPicture(picture: picture)
                    .id(picture)
            }
            
            VStack {
                VerticalSpace(64)
                
                HStack {
                    Spacer()
                    
                    MultiImagePicker(
                        pictures: Binding<[Picture]>(
                            get: { [] },
                            set: { if !$0.isEmpty { picture = $0[0] } }
                        ),
                        loadingCount:$loadingCount,
                        isPickingPhoto: $isPickingPhoto,
                        isLoading: $isLoading,
                        limit:1,
                        onSave: onSave) {
                            LargeActionWhiteButton(icon:"\u{e913}") {
                                isPickingPhoto = true;
                                isLoading = true;
                            }
                        }
                    .onChange(of: picture) {
                        onSave()
                    }
                    .padding(.trailing, 25)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}




// TODO:  Unify the below into a content wrapper struct



struct MultiImagePicker<ButtonContent: View>: View {
    @Binding var pictures:[Picture]
    @Binding var loadingCount:Int
    @Binding var isPickingPhoto:Bool
    @Binding var isLoading:Bool
    var limit:Int = Int.max
    var onSave: () -> Void = {}
    
    @ViewBuilder let content: ButtonContent;

    @StateObject private var photoPickerModel: PhotoPickerViewModel = PhotoPickerViewModel();
    @State private var newMedia: [Media] = [];
    @State private var newPictures: [Picture] = [];
    
    var body: some View {
        HStack {
            content
        }
        .onChange(of:isPickingPhoto) {
            isLoading = isPickingPhoto ? true : isLoading;
        }
        .onChange(of:newPictures) {
            withAnimation {
                pictures = pictures.filter() { !$0.deleted } + newPictures;
                newPictures = []
                loadingCount = 0
                onSave()
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
