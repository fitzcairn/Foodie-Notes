//
//  MealView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI
import UIKit.UIImage
import WrappingHStack
import SwipeActions


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
                .frame(maxWidth: .infinity, alignment: .leading)
            content()
        }
    }
    
    // TODO: Move to View class
    private var VerticalSpace: some View {
        Spacer()
            .frame(height:24)
    }
    
    private func getTestCourses() -> [Course] {
        var courses = [Course(mealId: meal.item.id)]
        courses[0].name = "Shampoo"
        courses[0].rating = 4
        courses[0].date = Date()
        courses[0].food = PicturesAndNotes()
        courses[0].food.notes = "Amazing!"
        return courses;
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color(Colors.BackgroundBgPrimary)

                ScrollView {
                    ZStack(alignment: .top) {
                        VStack {
                            // TODO: Replace with photo
                            Rectangle()
                                .frame(height:200)
                                .foregroundColor(.black)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Spacer()
                                .frame(height: 180)
                            
                            getEditableTextRow {
                                FoodieText(meal.item.venue.name, Colors.TextStaticTextPrimary, weight: .semibold)
                                    .padding(.horizontal, 4)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            getEditableTextRow {
                                HStack {
                                    FoodieIcon("\u{e903}", Colors.IconSecondary, padding:0)
                                    FoodieText(meal.item.date.formatted(date:.abbreviated, time:.omitted), Colors.TextStaticTextSecondary, size:12, weight:.medium)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
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
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(16)
                                .background(Colors.FillStaticFillPrimary)
                                .cornerRadius(8)
                                .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
                                .shadow(color: Colors.ShadowEdge, radius: 4, x: 0, y: 0)
                            }
                            
                            VerticalSpace
                            
                            getSection("Cuisine") {
                                HStack(alignment: .top, spacing: 8) {
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
                                    
                                    WrappingHStack(meal.item.cuisines, id: \.self) { cuisine in
                                        VStack {
                                            HStack(alignment: .center, spacing: 4) {
                                                FoodieText(cuisine.displayName, Colors.TextStaticTextSecondary, size:12, weight:.bold)
                                            }
                                            .fixedSize(horizontal: true, vertical: false)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 4)
                                            .frame(height: 28, alignment: .leading)
                                            .background(Colors.FillStaticFillSecondary)
                                            .cornerRadius(80)
                                            Spacer()
                                                .frame(height:8)
                                        }
                                        .frame(height:36)
                                    }
                                    
                                    
                                }
                                .padding(8)
                                .cornerRadius(8)
                            }
                            
                            
                            getSection("Menus") {
                                HStack(alignment: .top, spacing: 10) {
                                    HStack(alignment: .center) {
                                        
                                        // TODO: Replace with menu photo
                                        MealListPicture(picture:viewModel.getMealImageFor(meal.item))
                                            .padding(4)
                                            .frame(minWidth: 64, maxWidth: 64, minHeight:64, maxHeight: .infinity, alignment: .leading)
                                            .clipped()
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
                            
                            getSection("Courses") {
                                VStack {
                                    SwipeViewGroup {
                                        List {
                                            ForEach(getTestCourses(), id:\.self) { course in
                                                CourseListCard(course:course)
                                            }
                                        }
                                    }
                                    
                                    // Add Course button
                                    HStack {
                                        FoodieIcon("\u{e91f}", Colors.BorderActionBorderAction, padding:0)
                                        Spacer()
                                            .frame(width:8)
                                        FoodieText("Add a course", Colors.TextActionTextAction, size:14, weight:.semibold)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 64, maxHeight: 64, alignment: .center)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .inset(by: 0.75)
                                            .stroke(Colors.BorderStaticBorderSecondary, lineWidth: 1.5)
                                    )
                                }
                            }
                            
                            
                            BottomFade()
                        }
                        .padding(.horizontal, 24)
                    }
                }
                .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))

                
                // Main Nav Buttons
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
            .ignoresSafeArea(.all)
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
 )*/
