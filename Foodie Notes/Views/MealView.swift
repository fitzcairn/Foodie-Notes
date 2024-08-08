//
//  MealView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI
import UIKit.UIImage
import WrappingHStack


struct MealView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel:AppViewModel;
    
    @ObservedObject private var meal:WrappedStruct<Meal>;
    
    init(meal:Meal) {
        self.meal = WrappedStruct(withItem:meal)
    }
    
    // TODO: Move to View class
    private func getEditableTextRow(_ content:() -> some View) -> some View {
        VStack(alignment: .trailing, spacing: 4) {
            content()
        }
        .padding(12)
        .background(Colors.FillStaticFillPrimary)
        .cornerRadius(8)
        .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
        .shadow(color: Colors.ShadowEdge, radius: 4, x: 0, y: 0)
    }
    
    // TODO: Move to View class
    private func getSection(_ title:String, _ content:() -> some View) -> some View {
        VStack {
            FoodieText(title, Colors.TextStaticTextSecondary, size:12, weight:.semibold)
                .padding(8)
            content()
        }
    }
    
    private var VerticalSpace: some View {
        Spacer()
            .frame(height:24)
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    ZStack(alignment: .top) {
                        VStack {
                            
                            // TODO: Replace with photo
                            Rectangle()
                                .frame(height:200)
                                .foregroundColor(.black)
                            Color(Colors.BackgroundBgPrimary)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Spacer()
                                .frame(height: 180)
                            
                            getEditableTextRow {
                                FoodieText(meal.item.venue.name, Colors.TextStaticTextPrimary, weight: .semibold)
                                    .padding(.horizontal, 4)
                            }
                            
                            getEditableTextRow {
                                HStack {
                                    FoodieIcon("\u{e903}", Colors.IconSecondary, padding:0)
                                    FoodieText(meal.item.date.formatted(date:.abbreviated, time:.omitted), Colors.TextStaticTextSecondary, size:12, weight:.medium)
                                }
                            }
                            
                            getEditableTextRow {
                                LocationView(location: meal.item.venue.location)
                            }
                            
                            HStack(alignment: .center, spacing: 4) {
                                getEditableTextRow {
                                    RatingView(rating:meal.item.rating)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 6)
                                }
                                
                                
                                // No rating view
                                if (meal.item.venue.michelin == nil && meal.item.venue.guideLink?.url == nil) {
                                    getEditableTextRow {
                                        HStack {
                                            FoodieText("( not michelin rated )", Colors.TextStaticTextSecondary, size:12, weight:.medium)
                                                .padding(.vertical, 3)
                                            Spacer()
                                        }
                                    }
                                } else {
                                    if meal.item.venue.michelin != nil {
                                        getEditableTextRow {
                                            MichelinStarView(rating: meal.item.venue.michelin)
                                                .padding(.horizontal, 4)
                                                .padding(.vertical, 3)
                                        }
                                    }
                                    if meal.item.venue.guideLink?.url != nil {
                                        getEditableTextRow {
                                            HStack {
                                                FoodieIcon("\u{e911}", Colors.TextActionTextAction, padding:0)
                                                GuideLinkView(meal:meal.item)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                            VerticalSpace
                            
                            getSection("Overall Notes") {
                                HStack(alignment: .top, spacing: 0) {
                                    FoodieText("This is a note", Colors.TextStaticTextSecondary, size:14, weight:.semibold)
                                }
                                .padding(16)
                                .background(Colors.FillStaticFillPrimary)
                                .cornerRadius(8)
                                .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
                                .shadow(color: Colors.ShadowEdge, radius: 4, x: 0, y: 0)
                            }
                            
                            VerticalSpace
                            
                            getSection("Menus") {
                                HStack(alignment: .top, spacing: 10) {
                                    HStack(alignment: .center) {
                                        
                                        // TODO: Replace with menu photo
                                        MealListPicture(picture:viewModel.getMealImageFor(meal.item))
                                            .padding(4)
                                            .frame(minWidth: 64, maxWidth: 64, maxHeight: .infinity, alignment: .leading)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                        
                                    }
                                    
                                    HStack(alignment: .top, spacing: 4) {
                                        FoodieText("This is a menu description", Colors.TextStaticTextSecondary, size:14, weight:.semibold)
                                    }
                                    .padding(8)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                    
                                }
                                .background(Colors.FillStaticFillPrimary)
                                .cornerRadius(8)
                                .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
                                .shadow(color: Colors.ShadowEdge, radius: 4, x: 0, y: 0)
                            }
                            
                            VerticalSpace
                            
                            getSection("Cuisine") {
                                
                                GeometryReader { geo in
                                    
                                    WrappingHStack() {//alignment: .top, spacing: 8) {
                                        HStack(alignment: .center, spacing: 4) {
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .frame(width: 28, height: 28, alignment: .center)
                                        .cornerRadius(80)
                                        .overlay(
                                            ZStack {
                                                FoodieIcon("\u{e91f}", Colors.BorderActionBorderAction, padding:0)
                                                RoundedRectangle(cornerRadius: 80)
                                                    .inset(by: 0.75)
                                                    .stroke(Colors.BorderActionBorderAction, lineWidth: 1.5)
                                            }
                                        )
                                        
                                        
                                        ForEach(Array(zip(meal.item.cuisines.indices, meal.item.cuisines)), id: \.0) { index, cuisine in
                                            
                                            HStack(alignment: .center, spacing: 4) {
                                                FoodieText(cuisine.displayName, Colors.TextStaticTextSecondary, size:12, weight:.bold)
                                            }
                                            .fixedSize(horizontal: true, vertical: false)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 4)
                                            .frame(height: 28, alignment: .leading)
                                            .background(Colors.FillStaticFillSecondary)
                                            .cornerRadius(80)
                                            
                                            HStack(alignment: .center, spacing: 4) {
                                                FoodieText(cuisine.displayName, Colors.TextStaticTextSecondary, size:12, weight:.bold)
                                            }
                                            .fixedSize(horizontal: true, vertical: false)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 4)
                                            .frame(height: 28, alignment: .leading)
                                            .background(Colors.FillStaticFillSecondary)
                                            .cornerRadius(80)
                                            
                                            HStack(alignment: .center, spacing: 4) {
                                                FoodieText(cuisine.displayName, Colors.TextStaticTextSecondary, size:12, weight:.bold)
                                            }
                                            .fixedSize(horizontal: true, vertical: false)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 4)
                                            .frame(height: 28, alignment: .leading)
                                            .background(Colors.FillStaticFillSecondary)
                                            .cornerRadius(80)
                                            
                                            /*HStack {
                                             Text(cuisine.displayName)
                                             .font(.system(size:14, weight: .regular))
                                             .foregroundColor(.white)
                                             .padding(4)
                                             .fixedSize(horizontal: false, vertical: true)
                                             .lineLimit(1)
                                             .frame(minHeight:24)
                                             }
                                             .background(Color.gray)
                                             .clipShape(RoundedRectangle(cornerRadius: 10))
                                             .buttonStyle(.borderless)*/
                                        }
                                        
                                    }
                                    .padding(8)
                                    .frame(width: geo.size.width, alignment: .topLeading)
                                    .cornerRadius(8)
                                }
                            }

                            
                            BottomFade()

                            
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    

                    
                    
                
                    if (!meal.item.cuisines.isEmpty) {
                        CuisineSubViews.CuisineViewSection(
                            cuisines:meal.item.cuisines
                        )
                    }
                    
                    if !meal.item.notes.isEmpty {
                        NotesSubViews.NotesSection(
                            title:SectionTitle.notes,
                            note: meal.item.notes
                        )
                    }
                    
                    if viewModel.checkShow(meal.item.menu) {
                        PictureSubViews.PictureAndNotesViewSection(title: SectionTitle.menus, data:meal.item.menu)
                    }
                    
                    if !meal.item.courses.isEmpty {
                        CourseSubViews.CoursesViewSection(courses:meal.item.courses)
                    }
                }
                PrimaryButtonSubViews.MealViewPrimaryButtons(
                    backClosure: {
                        viewModel.saveEditedMealFor(meal.item)
                        self.presentationMode.wrappedValue.dismiss()
                    },
                    editMealDest: MealEditView(
                        meal:meal.item
                    ),
                    createCourseDest: CourseCreateView(
                        mealId: meal.item.id
                    )
                )
            }
            .onAppear() {
                meal.item = viewModel.getMealFor(meal.item.id) ?? Meal()
            }
            .navigationBarHidden(true)
        }
    }
}

/* TODO: move this into share button
 .navigationBarItems(
     leading: StyledTitleText(ViewTitle.viewMeal),
     trailing: ShareLink(
         item: "",
         subject: Text("Notes about my meal at \(meal.item.venue.name) on \(meal.item.date.formatted(date: .complete, time: .omitted))"),
         message: Text(ModelIOService.exportAsString(meal.item)),
         preview: SharePreview(
             "Notes about my meal at \(meal.item.venue.name) on \(meal.item.date.formatted(date: .complete, time: .omitted))",
             image: Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
         )
     ) {
         Image(systemName: "square.and.arrow.up.circle")
             .resizable()
             .frame(width: 30, height: 30)
             .foregroundColor(.gray)
     }
 )

 
 */


/* TODO: move this into the view card
if (!meal.cuisines.isEmpty) {
    HStack {
        Image(systemName: "fork.knife")
            .resizable()
            .scaledToFit()
            .frame(height: 18)
            .foregroundColor(Color.gray)
            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
            .padding(.trailing, 3)
        Text(meal.cuisines.map({$0.displayName}).joined(separator: ", "))
            .font(.system(size:14, weight: .regular))
            .foregroundColor(.gray)
            .fixedSize(horizontal: false, vertical: true)
            .lineLimit(1)
    }
} else {
    Spacer()
}*/
