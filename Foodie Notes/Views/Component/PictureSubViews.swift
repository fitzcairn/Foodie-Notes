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
            [GridItem(.flexible(minimum: PhotoDimensions.photoThumbWidth))] :
                [GridItem(.flexible(minimum: PhotoDimensions.photoThumbWidth)), GridItem(.flexible(minimum: PhotoDimensions.photoThumbWidth))]

            VStack(alignment: .center) {
                LazyVGrid(columns: columns, spacing:10) {
                    ForEach(pictures.indices, id: \.self) { index in
                        if edit && !pictures[index].deleted {
                            PhotoSubViews.PhotoEditView(
                                picture:Binding<Picture?>(
                                    get: { pictures[index] },
                                    set: { if $0 != nil { pictures[index] = $0! }})
                            )
                        } else if !pictures[index].deleted {
                            PhotoSubViews.PhotoShowView(picture:pictures[index])
                                .padding(.horizontal, -5)
                        }
                    }
                    if edit {
                        PhotoSubViews.PhotoPickerButton(
                            pictures: $pictures)
                        .buttonStyle(.plain)
                    }
                }
                .id(UUID())
            }
        }
    }
    
    struct BeveragePictureAndNotesEditSection: View {
        let title:String;
        @Binding var infoLink:InfoLink?;
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
                    .frame(width:data.pictures.isEmpty ? PhotoDimensions.photoThumbWidth : 2 * PhotoDimensions.photoThumbWidth)
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
                        
                        BeverageEditLinkView(infoLink: $infoLink, img: data.pictures.first?.photo?.full)
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
                    .frame(width:data.pictures.isEmpty ? PhotoDimensions.photoThumbWidth : 2 * PhotoDimensions.photoThumbWidth)
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
        var isBeverage = false;
        
        var body: some View {
            Section(header: Text(title)) {
                if let data = data {
                    HStack(alignment: .top) {
                        if !data.pictures.isEmpty {
                            MultiPictureView(pictures:Binding(
                                get: { data.pictures },
                                set: { _ = $0 })
                            )
                            .frame(width:data.pictures.count <= 1 ? PhotoDimensions.photoThumbWidth : 2 * PhotoDimensions.photoThumbWidth)
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
                            
                            if isBeverage {
                                BeverageLinkView(infoLink: data.infoLink, img: data.pictures.first?.photo?.full)
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
                        RatingEditView(rating:$rating)
                    }
                    .padding(.bottom, 4)
                    
                    LocationEditView(
                        location: $venue.location,
                        nearestRestaurant: $venue.name
                    )
                    .padding(.leading, 10)
                    
                    HStack {
                        MichelinSubViews.MichelinEditView(selection: $venue.michelin)
                            .padding(.leading, 8)
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
                        RatingEditView(rating:$rating)
                            .padding(.trailing, 15)
                    }
                }
            }
        }
    }
    
    struct MealPictureNameRatingView : View {
        @EnvironmentObject var viewModel:AppViewModel;
        var meal:Meal;
        
        //@State var showEdit:Bool = false;
        
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
                        RatingView(rating: meal.rating)
                    }
                    
                    // Only look up Michelin if we have a rating.
                    if (meal.venue.michelin != nil) {
                        GuideLinkView(meal:meal)
                            .padding(.leading, 10)
                    }
                    
                    if (meal.venue.location != nil) {
                        LocationView(location: meal.venue.location)
                            .padding(.leading, 10)
                    }
                }
            }
            /*.onTapGesture {
                showEdit = true;
            }
            .sheet(isPresented: $showEdit) {
                Button("hi") {
                    showEdit = false;
                }
            }*/
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
                RatingView(rating: rating ?? 0)
            }
        }
    }

}
