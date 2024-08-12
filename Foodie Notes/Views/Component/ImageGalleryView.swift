//
//  ImageGalleryView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/12/24.
//

import SwiftUI

enum GallerySource {
    case picture(Picture?)
    case pictureAndNotes(PicturesAndNotes)
    
    var images: [Photo] {
        switch self {
        case .picture (let picture):
            return picture != nil && picture?.photo == nil ? [] : [picture!.photo!]
        case .pictureAndNotes(let pictureAndNotes):
            return pictureAndNotes.pictures.filter { $0.photo != nil }.map { $0.photo! }
        }
    }
}

struct ImageShow: View {
    let src:GallerySource;
    @State var showSheet:Bool = false;
    
    var body: some View {
        MedActionWhiteButton(icon: "\u{e914}") {
            showSheet.toggle()
        }
        .sheet(isPresented: $showSheet) {
            ImageSheetView(src:src, showSheet: $showSheet)
        }
    }
}

struct ExpandableImageGallery<Content: View>: View {
    let src:GallerySource;
    let content: Content;
    
    init(src: GallerySource, @ViewBuilder _ content: () -> Content) {
        self.src = src;
        self.content = content()
    }
    
    @State var showSheet:Bool = false;
    
    var body: some View {
        content
            .onTapGesture {
                showSheet.toggle()
            }
            .sheet(isPresented: $showSheet) {
                ImageSheetView(src:src, showSheet: $showSheet)
            }
    }
}

private struct ImageSheetView: View {
    let src:GallerySource;
    @Binding var showSheet:Bool;
    
    var body: some View {
        ZStack {
            ImageGalleryView(src)
                .padding(.horizontal, 0)
                .padding(.top, 80)
                .padding(.bottom, 118)
            
            VStack(alignment: .leading, spacing: 16) {
                Spacer()
                
                HStack {
                    LargeActionRedButton(icon:"\u{e900}") {
                        showSheet.toggle()
                    }
                    .padding(.leading, -8)
                    .padding(.bottom, 0)
                    Spacer()
                }
                .padding(.horizontal, 32)
            }
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .presentationDetents([.fraction(0.95)])
        .presentationContentInteraction(.scrolls)
        .presentationBackground(alignment: .bottom) {
            Color(Colors.BackgroundBgPrimary)
                .cornerRadius(24)
        }
    }
}

private struct ImageGalleryView: View {
    let images:[Photo]
    
    init(_ src: GallerySource) {
        self.images = src.images
    }
    
    var body: some View {
        if images.count > 0 {
            VStack(alignment: .center, spacing: 0) {
                PhotoView(img: images.first!.full, contentMode: .fit)
            }
        } else {
            // TODO: Implement Gallery
            VStack(alignment: .center, spacing: 0) {
                PhotoView(img: images.first!.full, contentMode: .fit)
            }
        }
    }
}
