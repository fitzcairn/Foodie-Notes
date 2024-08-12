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

struct ButtonForExpandableImageGallery: View {
    let src:GallerySource;
    @State var showSheet:Bool = false;
    
    var body: some View {
        if src.isEmpty {
            EmptyView()
        } else {
            MedActionWhiteButton(icon: "\u{e914}") {
                showSheet.toggle()
            }
            .sheet(isPresented: $showSheet) {
                ImageSheetView(src:src, showSheet: $showSheet)
            }
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
        if src.isEmpty {
            EmptyView()
        } else {
            content
                .onTapGesture {
                    showSheet.toggle()
                }
                .sheet(isPresented: $showSheet) {
                    ImageSheetView(src:src, showSheet: $showSheet)
                }
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
    
    @State private var image:Photo;
    
    init(_ src: GallerySource) {
        self.images = src.images
        self._image = State.init(initialValue: images.last!)//.first!)
    }
    
    var body: some View {
        if images.count == 0 {
            VStack(alignment: .center, spacing: 0) {
                ImageGalleryImage(photo: image)
            }
        } else {
            VStack {
                ImageGalleryImage(photo: image)
                    .id(image)
                Spacer()
                ImageGalleryCarousel(images:images, selected:$image)
            }
        }
    }
}

private struct ImageGalleryCarousel: View {
    let images:[Photo]
    @Binding var selected:Photo;
    @State private var focusedIndex:Int = 0;
    
    var body: some View {
        ScrollViewReader { v in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(Array(zip(images.indices, images)), id: \.0) { index, img in
                        PhotoView(img: img.thumb, contentMode: .fill)
                            .frame(width: 64, height: 64)
                            .clipped()
                            .cornerRadius(8)
                            .onTapGesture {
                                selected = img;
                                focusedIndex = index
                            }
                            .opacity(selected == img ? 1 : 0.5)
                            .onAppear {
                                if selected == img {
                                    focusedIndex = index
                                }
                            }
                    }
                }
                .scrollTargetLayout()
                .onChange(of: focusedIndex) {
                    withAnimation {
                        v.scrollTo(focusedIndex, anchor: .center)
                    }
                }
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
    let photo:Photo
    @State private var showFull:Bool = false;
    @State private var screenW = 0.0
    @State private var scale = 1.0
    @State private var lastScale = 0.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    
    var body: some View {
        PhotoView(img: photo.full, contentMode: .fit)
            .onTapGesture {
                // Disabled for now pending discussion with designer.
                // showFull.toggle()
            }
            .fullScreenCover(isPresented: $showFull) {
                ZStack {
                    Color.black
                    
                    GeometryReader { geometry in
                        
                        PhotoView(img: photo.full, contentMode: .fit)
                            .scaleEffect(scale)
                            .offset(offset)
                            .gesture(
                                MagnificationGesture(minimumScaleDelta: 0)
                                    .onChanged({ value in
                                        withAnimation(.interactiveSpring()) {
                                            scale = handleScaleChange(value)
                                        }
                                    })
                                    .onEnded({ _ in
                                        lastScale = scale
                                    })
                                    .simultaneously(with: DragGesture(minimumDistance: 0)
                                        .onChanged({ value in
                                            withAnimation(.interactiveSpring()) {
                                                offset = handleOffsetChange(value.translation)
                                            }
                                        })
                                            .onEnded({ _ in
                                                lastOffset = offset
                                            })
                                    )
                            )
                            .onAppear {
                                screenW = geometry.size.width
                                offset.height = (UIScreen.main.bounds.height - geometry.size.height)
                                offset.width = (UIScreen.main.bounds.width - geometry.size.width)

                            }
                    }
                }
                .onTapGesture {
                    showFull.toggle()
                }
                .onAppear {
                    screenW = 0.0
                    scale = 1.0
                    lastScale = 0.0
                    offset = .zero
                    lastOffset = .zero
                }
            }
    }
                                                        
    private func handleScaleChange(_ zoom: CGFloat) -> CGFloat {
        lastScale + zoom - (lastScale == 0 ? 0 : 1)
    }

    private func handleOffsetChange(_ offset: CGSize) -> CGSize {
        var newOffset: CGSize = .zero
        
        newOffset.width = offset.width + lastOffset.width
        newOffset.height = offset.height + lastOffset.height
        
        return newOffset
    }
}
