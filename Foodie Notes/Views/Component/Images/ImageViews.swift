//
//  PhotoViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/12/24.
//

import SwiftUI

// Expandable clipped image for a variable height row
struct VariableHeightListPicture : View {
    var picture: Picture?;
    var num: Int = 0;

    // TODO: Swap this to use the cover image size, once that exists.
    var body: some View {
        ZStack(alignment: .bottom) {
            PictureView(picture: picture, edit:true)
                .frame(minWidth:56, maxWidth:56, minHeight: 56, maxHeight: .infinity)
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

struct ImageLoadingView : View {
    var body: some View {
        ImageLoadingBorder {
            Rectangle()
                .padding(0)
                .cornerRadius(8)
                .foregroundStyle(.clear)
        }
    }
}

struct ImageLoadingBorder<ForContent: View> : View {
    @ViewBuilder let content:ForContent
    
    @State var isAnimating:Bool = false;

    var body: some View {
        content
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
                .foregroundColor(Colors.FillStaticFillTertiary)
                .scaledToFill()
            if edit {
                FoodieIcon("\u{e913}", .white, size:24, padding:0)
            }
        }
    }
}

struct PhotoView: View {
    @StateObject var photoModel:AsyncPhotoViewModel = AsyncPhotoViewModel()
    let img: SavedImage;
    var contentMode:ContentMode = .fill;
    @State var isAnimating:Bool = false;

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
                    .aspectRatio(contentMode: contentMode)
            }
        )
    }
}

private struct PictureView : View {
    var picture: Picture?;
    var useThumb: Bool = true;
    var edit: Bool = false;
    
    var body: some View {
        HStack {
            if picture == nil || picture!.deleted || picture?.photo == nil  {
                NoPhotoPlaceholderView(edit:edit)
            }
            else {
                PhotoView(img: useThumb ? picture!.photo!.thumb : picture!.photo!.full)
            }
        }
    }
}

