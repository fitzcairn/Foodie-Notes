//
//  PictureSubViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/1/24.
//

import SwiftUI

// All views related to showing pictures and annotations
struct PictureSubViews {
    // Multi picture grid
    struct MultiPictureView: View {
        @Binding var pictures:[Picture]
        var edit:Bool = false;

        var body: some View {
            let columns = (edit && pictures.isEmpty) || (!edit && pictures.count == 1) ?
            [GridItem(.flexible(minimum: PhotoDimensions.photoWidth))] :
                [GridItem(.flexible(minimum: PhotoDimensions.photoWidth)), GridItem(.flexible(minimum: PhotoDimensions.photoWidth))]

            VStack(alignment: .center) {
                LazyVGrid(columns: columns, spacing:10) {
                    ForEach(pictures.indices, id: \.self) { index in
                        if edit {
                            PhotoSubViews.PhotoEditView(
                                picture:Binding<Picture?>(
                                    get: { pictures[index] },
                                    set: { if $0 != nil { pictures[index] = $0! }})
                                )
                        } else {
                            PhotoSubViews.PhotoShowView(picture:pictures[index])
                                .padding(.horizontal, -5)
                        }
                    }
                    if edit {
                        PhotoSubViews.PhotoPickerButton(pictures: $pictures)
                            .buttonStyle(.plain)
                    }
                }
            }
        }
    }
    
    struct PictureAndNotesEditSection: View {
        let title:String;
        @Binding var data:PicturesAndNotes;
        
        var body: some View {
            Section(header: Text(title)) {
                HStack(alignment: .top) {
                    MultiPictureView(
                        pictures:Binding<[Picture]>(
                            get: {
                                data.pictures
                            },
                            set: {
                                data.pictures = $0;
                            }),
                        edit:true)
                    .frame(width:data.pictures.isEmpty ? PhotoDimensions.photoWidth : 2 * PhotoDimensions.photoWidth)
                    .padding(.trailing, 5)
                    StyledTextField(inputText:$data.notes)
                    Spacer()
                }
            }
        }
    }
    
    struct PictureAndNotesViewSection: View {
        let title:String;
        let data:PicturesAndNotes?;
        
        var body: some View {
            Section(header: Text(title)) {
                if let data = data {
                    HStack(alignment: .top) {
                        if !data.pictures.isEmpty {
                            MultiPictureView(pictures:Binding(
                                get: { data.pictures },
                                set: { _ = $0 })
                            )
                            .frame(width:data.pictures.count <= 1 ? PhotoDimensions.photoWidth : 2 * PhotoDimensions.photoWidth)
                            .padding(.trailing, 5)
                        }
                        NotesSubViews.NotesView(inputText:data.notes)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                } else {
                    EmptyView()
                }
            }
        }
    }
    
    struct PictureNameRatingEditView : View {
        @Binding var name: String
        @Binding var picture: Picture?
        @Binding var rating: Int

        var body: some View {
            VStack {
                HStack {
                    PhotoSubViews.PhotoEditView(picture:$picture)
                    StyledTextField(inputText:$name)
                        .padding(.leading, 10)
                        .padding(.trailing, -10)
                    Spacer()
                    RatingSubViews.RatingEditView(rating:$rating)
                        .padding(.trailing, 15)
                }
                MichelinEditView()
            }
        }
    }
    
    struct MichelinEditView: View {
        let ratings = Michelin.allCases
        
        @State var selection:Michelin = .none
        var body: some View {
            VStack {
                Picker("Michelin Guide", selection: $selection) {
                    ForEach(Array(zip(ratings.indices, ratings)), id: \.0) { index, rating in
                        switch(rating) {
                        case .none:
                            MichelinRatingViews.None()
                        case .bibGourmand:
                            MichelinRatingViews.BibGourmand()
                        case .oneStar:
                            MichelinRatingViews.OneStar()
                        case .twoStar:
                            MichelinRatingViews.TwoStar()
                        case .threeStar:
                            MichelinRatingViews.ThreeStar()
                        }
                    }
                }
                .pickerStyle(.menu)
            }
        }
    }
    
    private struct MichelinRatingViews {
        private static let imageDim:CGFloat = 18;
        
        struct None : View {
            var body: some View {
                HStack {
                    EmptyView()
                }
                .frame(width: imageDim, height: imageDim)
            }
        }
        
        struct BibGourmand : View {
            var body: some View {
                HStack {
                    Image("bib-gourmand")
                        .resizable()
                        .frame(width: imageDim, height: imageDim)
                }
            }
        }

        struct OneStar : View {
            var body: some View {
                HStack {
                    Image("1star")
                        .resizable()
                        .frame(width: imageDim, height: imageDim)
                }
            }
        }

        struct TwoStar : View {
            var body: some View {
                HStack {
                    Image("1star")
                        .resizable()
                        .frame(width: imageDim, height: imageDim)
                    Image("1star")
                        .resizable()
                        .frame(width: imageDim, height: imageDim)
                }
            }
        }

        struct ThreeStar : View {
            var body: some View {
                HStack {
                    Image("1star")
                        .resizable()
                        .frame(width: imageDim, height: imageDim)
                    Image("1star")
                        .resizable()
                        .frame(width: imageDim, height: imageDim)
                    Image("1star")
                        .resizable()
                        .frame(width: imageDim, height: imageDim)
                }
            }
        }

    }
    
    
    struct PictureNameRatingView : View {
        let name: String?
        let picture: Picture?
        let rating:Int?;
        
        var body: some View {
            HStack {
                PhotoSubViews.PhotoShowView(picture:picture)
                Text(name ?? "")
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    .padding(.leading, 10)
                Spacer()
                RatingSubViews.RatingView(rating: rating ?? 0)
            }
        }
    }
}
