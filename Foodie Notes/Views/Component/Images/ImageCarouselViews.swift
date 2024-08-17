//
//  ImageCarouselViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/13/24.
//

import SwiftUI
import WrappingHStack


struct SingleImageCarousel: View {
    @Binding var picture:Picture?
    var mutable:Bool = false;
    @State var isPickingPhoto: Bool = false;
    @State var isLoading:Bool = false;
    var onSave:() -> Void = {}
    
    var body: some View {
        if (picture?.photo == nil || picture!.deleted) {
            SingleImagePicker(
                picture: $picture,
                isPickingPhoto: $isPickingPhoto,
                isLoading: $isLoading,
                onSave:onSave) {
                    if !isLoading {
                        AddImageButton(loading:$isLoading) {
                            isPickingPhoto = true;
                        }
                    } else {
                        ImageLoadingView()
                            .frame(width: 80, height: 80, alignment: .center)
                    }
                }
        } else {
            ExpandableImageGallery(src: .picture(picture)) {
                MutableImage(picture: picture!, mutable: mutable, isLoading:$isLoading) {
                    picture = nil;
                }
            }
        }
    }
}

struct FlexibleImageGrid : View {
    @Binding var pictures:[Picture]
    var mutable:Bool = false;
    var onSave:() -> Void = {}
    
    @State private var loadingCount:Int = 0;
    @State var isPickingPhoto: Bool = false;
    @State var isLoading:Bool = false;

    var body: some View {
        let columns: [GridItem] = [
            GridItem(.adaptive(minimum: 80, maximum: 80), spacing:4)
        ]
        
        LazyVGrid(columns: columns, spacing:4) {
            ForEach(pictures.filter { $0.photo != nil }, id: \.self) { picture in
                MutableImage(picture: picture, mutable: mutable, isLoading:$isLoading) {
                    if let index = pictures.firstIndex(where: { $0 == picture }) {
                        pictures.remove(at: index)
                    }
                }
            }
            .id(pictures.count)
            
            ForEach(0..<loadingCount, id: \.self) { _ in
                ImageLoadingView()
                    .frame(width: 80, height: 80, alignment: .center)
            }
            
            MultiImagePicker(
                pictures: $pictures,
                loadingCount:$loadingCount,
                isPickingPhoto: $isPickingPhoto,
                isLoading: $isLoading,
                onSave:onSave) {
                AddImageButton(loading:$isLoading) {
                    isPickingPhoto = true;
                }
            }
        }
        .frame(maxWidth:.infinity)
    }
}

private struct MutableImage: View {
    let picture:Picture
    let mutable:Bool
    @Binding var isLoading:Bool;
    
    let action:() -> Void;
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ExpandableImageGallery(src: .picture(picture)) {
                PhotoView(img: picture.photo!.thumb, contentMode: .fill, isLoading:$isLoading)
                    .frame(width: 80, height: 80)
                    .clipped()
                    .cornerRadius(8)
            }
            
            if (mutable) {
                Button(
                    action: action,
                    label: {
                        Rectangle()
                            .frame(width:32, height:32)
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 0,
                                    bottomLeadingRadius: 8,
                                    bottomTrailingRadius: 0,
                                    topTrailingRadius: 8
                                )
                            )
                    }
                )
                .buttonStyle(DeleteButtonStyle(icon:"\u{e90a}"))
            }
        }
        .contentShape(Rectangle())
        .frame(width:80, height:80)
    }
}

private struct DeleteButtonStyle: ButtonStyle {
    let icon:String;

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Colors.FillActionFillActionPressed : Colors.FillActionFillAction)
            .overlay() {
                FoodieIcon(icon, configuration.isPressed ? Colors.FillActionFillActionPressedIcon : Color.white, size:24, padding:0)
            }
    }
}

