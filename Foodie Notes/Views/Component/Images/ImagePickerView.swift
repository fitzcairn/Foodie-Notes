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
    
    var background : some View {
        Rectangle()
            .foregroundColor(Colors.FillStaticFillNull)
            .scaledToFill()
            
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            background
                .frame(height:110)
            
            withAnimation {
                CoverPicture(picture: picture, isLoading:$isLoading)
                    .id(picture)
            }
            
            if (viewModel.isPictureEmpty(picture)) {
                ZStack(alignment: .center) {
                    SingleImagePickerButton(
                        picture:$picture,
                        isPickingPhoto: $isPickingPhoto,
                        isLoading: $isLoading,
                        onSave: onSave,
                        content: {
                            FoodieIcon("\u{e913}", Colors.TextActionTextAction, size:32, padding:0)
                                .onTapGesture() {
                                    isPickingPhoto = true;
                                    isLoading = true;
                                }
                                .padding(20)
                                .background(Colors.FillStaticFillNull)
                        },
                        loading: {
                                ImageLoadingView()
                        })
                }
                .background(Colors.FillStaticFillNull)
                .padding(.horizontal, 16)
                .padding(.top, 64)
                .padding(.bottom, 16)
                .frame(height:270)
            } else {
                VStack {
                    VerticalSpace(54)
                    
                    HStack {
                        Spacer()
                        
                        SingleImagePickerButton(
                            picture:$picture,
                            isPickingPhoto: $isPickingPhoto,
                            isLoading: $isLoading,
                            onSave: onSave,
                            content: {
                                LargeActionWhiteButton(icon:"\u{e913}") {
                                    isPickingPhoto = true;
                                    isLoading = true;
                                }
                                .onChange(of: picture) {
                                    onSave()
                                }
                                .padding(.trailing, 25)
                            },
                            loading: {
                                EmptyView()
                                /*ImageLoadingView(width:48, height:48)
                                    .padding(.trailing, 25)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)*/
                            })
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}


struct SingleImagePickerButton<ButtonContent: View, LoadingContent: View>: View {
    @Binding var picture:Picture?
    @Binding var isPickingPhoto:Bool
    @Binding var isLoading:Bool
    var limit:Int = Int.max
    var onSave: () -> Void = {}
    
    @ViewBuilder let content: ButtonContent;
    @ViewBuilder let loading: LoadingContent;
    
    var body: some View {
        MultiImagePickerButton(
            pictures: Binding<[Picture]>(
                get: { [] },
                set: { if !$0.isEmpty { picture = $0[0] } }),
            loadingCount: Binding<Int>(
                get: { 0 },
                set: { _ = $0 }),
            isPickingPhoto: $isPickingPhoto,
            isLoading: $isLoading,
            limit:1,
            onSave:onSave,
            content: {
                content
            },
            loading: {
                loading
            })
    }
}


struct MultiImagePickerButton<ButtonContent: View, LoadingContent: View>: View {
    @Binding var pictures:[Picture]
    @Binding var loadingCount:Int
    @Binding var isPickingPhoto:Bool
    @Binding var isLoading:Bool
    var limit:Int = Int.max
    var onSave: () -> Void = {}
    
    @ViewBuilder let content: ButtonContent;
    @ViewBuilder let loading: LoadingContent;

    @StateObject private var photoPickerModel: PhotoPickerViewModel = PhotoPickerViewModel();
    @State private var newMedia: [Media] = [];
    @State private var newPictures: [Picture] = [];
    
    var body: some View {
        HStack {
            if !isLoading {
                content
            } else {
                loading
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
                    if newPictures.isEmpty {
                        isLoading = false;
                    }
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
