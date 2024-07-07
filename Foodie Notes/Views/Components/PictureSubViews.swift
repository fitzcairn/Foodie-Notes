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
            [GridItem(.flexible(minimum: Constant.photoWidth))] :
                [GridItem(.flexible(minimum: Constant.photoWidth)), GridItem(.flexible(minimum: Constant.photoWidth))]

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
                    .frame(width:data.pictures.isEmpty ? Constant.photoWidth : 2 * Constant.photoWidth)
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
                            .frame(width:data.pictures.count <= 1 ? Constant.photoWidth : 2 * Constant.photoWidth)
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
            HStack {
                PhotoSubViews.PhotoEditView(picture:$picture)
                StyledTextField(inputText:$name)
                    .padding(.leading, 10)
                    .padding(.trailing, -10)
                Spacer()
                RatingSubViews.RatingEditView(rating:$rating)
                    .padding(.trailing, 15)
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
