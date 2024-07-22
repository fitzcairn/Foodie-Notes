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
        @State private var isLoadingPhoto: Bool = false;
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
                        PhotoSubViews.PhotoPickerButton(
                            isLoadingPhoto:$isLoadingPhoto,
                            pictures: $pictures)
                            .buttonStyle(.plain)
                    }
                }
            }
        }
    }
    
    struct BeveragePictureAndNotesEditSection: View {
        let title:String;
        @Binding var data:PicturesAndNotes;
        @Binding var sameAsPrev:Bool?;

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
                    VStack {
                        HStack {
                            Button {
                                sameAsPrev = sameAsPrev == nil ? true : !sameAsPrev!
                            }
                            label: {
                                if sameAsPrev != nil && sameAsPrev! {
                                    HStack {
                                        Image(systemName: "checkmark.square")
                                            .resizable()
                                            .frame(width: 18, height: 18)
                                            .foregroundColor(Color.red)
                                    }
                                } else {
                                    HStack {
                                        Image(systemName: "square")
                                            .resizable()
                                            .frame(width: 18, height: 18)
                                            .foregroundColor(Color.gray)
                                    }
                                    .opacity(0.6)
                                }
                            }
                            .buttonStyle(.plain)
                            Text("Shared with Previous Course")
                                .font(.system(size:14, weight: .regular))
                                .italic()
                                .opacity(sameAsPrev != nil && sameAsPrev! ? 1.0 : 0.4)
                            Spacer()
                        }
                        StyledTextField(inputText:$data.notes)
                            .padding(.trailing, -8)
                    }
                    Spacer()
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
                        .padding(.trailing, -8)
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
                        VStack {
                            if (data.sameAsPrevious != nil && data.sameAsPrevious!) {
                                HStack {
                                    Text("Pairing Shared with Previous Course")
                                        .font(.system(size:14, weight: .regular))
                                        .italic()
                                        .opacity(0.4)
                                    Spacer()
                                }
                            }
                            if !data.notes.isEmpty {
                                HStack {
                                    NotesSubViews.NotesView(inputText:data.notes)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Spacer()
                                }
                            }
                        }
                    }
                } else {
                    EmptyView()
                }
            }
        }
    }
    
    struct MealPictureNameRatingEditView : View {
        @Binding var picture: Picture?
        @Binding var rating: Int
        @Binding var venue: Venue

        var body: some View {
            HStack {
                VStack {
                    PhotoSubViews.PhotoEditView(picture:$picture)
                }
                VStack {
                    HStack {
                        StyledTextField(inputText:$venue.name)
                            .padding(.leading, 10)
                            .padding(.trailing, -10)
                        Spacer()
                        RatingSubViews.RatingEditView(rating:$rating)
                    }
                    .padding(.bottom, 4)
                    
                    //VenueSubViews.GuideLinkEditView(venue:$venue)
                    //    .padding(.leading, 10)
                    
                    VenueSubViews.LocationEditView(
                        venue: $venue,
                        nearestRestaurant: $venue.name
                    )
                    HStack {
                        MichelinSubViews.MichelinEditView(selection: $venue.michelin)
                            .padding(.leading, 10)
                        Spacer()
                    }
                }
            }
        }
    }

    struct CoursePictureNameRatingEditView : View {
        @Binding var name: String
        @Binding var picture: Picture?
        @Binding var rating: Int

        var body: some View {
            HStack {
                VStack {
                    PhotoSubViews.PhotoEditView(picture:$picture)
                }
                VStack {
                    HStack {
                        StyledTextField(inputText:$name)
                            .padding(.leading, 10)
                            .padding(.trailing, -10)
                        Spacer()
                        RatingSubViews.RatingEditView(rating:$rating)
                            .padding(.trailing, 15)
                    }
                }
            }
        }
    }
    
    struct MealPictureNameRatingView : View {
        @EnvironmentObject var viewModel:AppViewModel;
        let meal:Meal;
        
        var body: some View {
            HStack {
                VStack {
                    PhotoSubViews.PhotoShowView(picture:viewModel.getMealImageFor(meal))
                }
                VStack {
                    HStack {
                        MichelinSubViews.MichelinNameView(name: meal.venue.name, rating: meal.venue.michelin)
                            .padding(.leading, 10)
                        Spacer()
                        RatingSubViews.RatingView(rating: meal.rating)
                    }
                    
                    VenueSubViews.GuideLinkView(meal:meal)
                        .padding(.leading, 10)
                    
                    if (meal.venue.city != nil) {
                        VenueSubViews.LocationView(venue: meal.venue)
                            .padding(.leading, 10)
                    }
                }
            }
        }
    }
    
    struct CoursePictureNameRatingView : View {
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
