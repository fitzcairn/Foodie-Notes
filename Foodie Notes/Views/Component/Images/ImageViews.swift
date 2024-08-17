//
//  PhotoViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/12/24.
//

import SwiftUI

struct ImageLoadingView : View {
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .padding(0)
                .cornerRadius(8)
                .foregroundStyle(Colors.FillStaticFillNull)
            
            ImageLoadingBorder {
                Rectangle()
                    .padding(0)
                    .cornerRadius(4)
                    .foregroundStyle(Colors.FillStaticFillNull)
                    .frame(width: 22, height: 22)
            }
        }
    }
}

struct ImageLoadingBorder<ForContent: View> : View {
    @ViewBuilder let content:ForContent
    
    @State var isAnimating:Bool = false;

    var body: some View {
        content
            .background(Colors.FillStaticFillNull)
            .borderLoadingAnimation(isAnimating: $isAnimating)
            .onAppear {
                withAnimation(.linear(duration: 4)
                    .repeatForever(autoreverses: false)) {
                        isAnimating = true
                    }
            }
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

// Clipped image for course list.
struct CourseListPicture : View {
    var picture: Picture?;
    var num: Int = 0;

    var body: some View {
        ZStack(alignment: .bottom) {
            PictureView(picture: picture)
                .frame(width:56, height:56)
                .clipped()
            if picture != nil && num > 1 {
                HStack {
                    FoodieIcon("\u{e915}", .white, size:24, padding:0)
                    FoodieText("\(num)", .white, size:12, weight:.medium)
                        .padding(.leading, -6)
                }
            }
        }
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

struct NoPhotoPlaceholderView: View {
    var edit: Bool = false;

    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .foregroundColor(Colors.FillStaticFillNull)
                .scaledToFill()

            FoodieIcon("\u{e913}", Colors.IconSecondary, size:24, padding:0)
        }
    }
}

struct PhotoView: View {
    @StateObject var photoModel:AsyncPhotoViewModel = AsyncPhotoViewModel()
    let img: SavedImage;
    var contentMode:ContentMode = .fill;
    
    @Binding var isLoading:Bool;

    var body: some View {
        AsyncImageView(
            source: photoModel,
            img: img,
            progressContent: { 
                ImageLoadingView()
                    .frame(width: 80, height: 80, alignment: .center)
            },
            photoContent: {
                let image = UIImage(data: photoModel.loadedImg?.imgData ?? Data()) ?? UIImage()
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: contentMode)
                    .onAppear() {
                        isLoading = false;
                    }
            }
        )
    }
}

struct PictureView : View {
    var picture: Picture?;
    var useThumb: Bool = true;
    var showLoading: Bool = false;

    @State var isLoading:Bool = false;
    
    var body: some View {
        HStack {
            if picture == nil || picture!.deleted || picture?.photo == nil  {
                if showLoading {
                    ImageLoadingView()
                } else {
                    NoPhotoPlaceholderView()
                }
            }
            else {
                PhotoView(img: useThumb ? picture!.photo!.thumb : picture!.photo!.full, isLoading: $isLoading)
            }
        }
    }
}

