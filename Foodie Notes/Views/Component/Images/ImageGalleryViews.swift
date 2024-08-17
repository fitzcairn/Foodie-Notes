//
//  ImageGalleryView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/12/24.
//

import SwiftUI
import Combine


enum GallerySource {
    case picture(Picture?)
    case pictureAndNotes(PicturesAndNotes)
    case list([Picture])
    
    var images: [Photo] {
        switch self {
        case .picture (let picture):
            return picture != nil && picture?.photo == nil ? [] : [picture!.photo!]
        case .pictureAndNotes(let pictureAndNotes):
            return pictureAndNotes.pictures.filter { $0.photo != nil }.map { $0.photo! }
        case .list(let list):
            return list.filter { $0.photo != nil }.map { $0.photo! }
        }
    }
    
    var isEmpty: Bool {
        switch self {
        case .picture (let picture):
            return picture == nil || picture?.photo == nil
        case .pictureAndNotes(let pictureAndNotes):
            return pictureAndNotes.pictures.filter { $0.photo != nil }.map { $0.photo! }.isEmpty
        case .list(let list):
            return list.filter { $0.photo != nil }.map { $0.photo! }.isEmpty
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
                if !src.isEmpty {
                    showSheet.toggle()
                }
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
        HStack(alignment: .top) {
            HStack(alignment: .center, spacing: 4) {
                SmallActionBackButton(icon: "\u{e900}") {
                    showSheet.toggle()
                }
            }
            .padding(.horizontal, 16)
            .frame(width: 48, height: 48, alignment: .center)
            .cornerRadius(80)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, -8) // Hack

        Divider()
            .padding(.bottom, 8)
        
        ZStack {
            ImageGalleryView(src)
                .padding(.horizontal, 0)
                .padding(.top, 80)
                .padding(.bottom, 118)
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
    
    @State private var selectedGallery:Int = 0;
    @State private var selectedCarousel:Int = 0;

    
    init(_ src: GallerySource) {
        self.images = src.images
    }
    
    var body: some View {
        if images.count == 1 {
            VStack(alignment: .center, spacing: 0) {
                ImageGalleryImage(images:images, selectedGallery:$selectedGallery, selectedCarousel:$selectedCarousel)
            }
        } else {
            VStack {
                ImageGalleryImage(images:images, selectedGallery:$selectedGallery, selectedCarousel:$selectedCarousel)
                    .id(selectedGallery)
                Spacer()
                ImageGalleryCarousel(images:images, selectedGallery:$selectedGallery, selectedCarousel:$selectedCarousel)
                    .id(selectedCarousel)
            }
        }
    }
}

private struct ImageGalleryCarousel: View {
    let images:[Photo]
    @Binding var selectedGallery:Int
    @Binding var selectedCarousel:Int
    
    @State var test:Int = 0;

    var body: some View {
        ScrollViewReader { carousel in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(Array(zip(images.indices, images)), id: \.0) { index, img in
                        PhotoView(img: img.thumb, contentMode: .fill)
                            .frame(width: 64, height: 64)
                            .clipped()
                            .cornerRadius(8)
                            .opacity(selectedGallery == index ? 1 : 0.5)
                            .onTapGesture {
                                selectedGallery = index;
                            }
                    }
                }
                .scrollTargetLayout()
                .onChange(of: selectedGallery) {
                    withAnimation {
                        carousel.scrollTo(selectedGallery, anchor: .center)
                    }
                }
                /*.onChange(of: selectedGallery) {
                    print("Carousel got a change to \(selectedGallery)")
                    test = max(test, selectedGallery)
                    selectedCarousel = test
                }*/

            }
            .contentMargins(24, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
        }
    }
    
    private var emptyFrame : some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(width: 64, height: 64)
    }
}

private struct ImageGalleryImage: View {
    let images:[Photo]
    @Binding var selectedGallery:Int
    @Binding var selectedCarousel:Int
    
    @State private var showFull:Bool = false;
    @State private var screenW = 0.0
    @State private var scale = 1.0
    @State private var lastScale = 0.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        GeometryReader { geo in
            TabView(selection:$selectedGallery) {
                ForEach(Array(zip(images.indices, images)), id: \.0) { index, img in
                    PhotoView(img: img.full, contentMode: .fit)
                        .frame(width:geo.size.width)
                        .tag(index)
                        .transaction { $0.animation = nil }
                }
                .transaction { $0.animation = nil }

            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .transaction { $0.animation = nil }
        }
    }
}
