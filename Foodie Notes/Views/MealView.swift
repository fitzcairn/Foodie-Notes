//
//  MealView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI
import WrappingHStack
import SwipeActions


struct MealView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel:AppViewModel;
    
    @ObservedObject private var meal:WrappedStruct<Meal>;
    
    init(meal:Meal) {
        self.meal = WrappedStruct(withItem:meal)
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color(Colors.BackgroundBgPrimary)

                ScrollView {
                    ZStack(alignment: .top) {
                        ZStack(alignment: .top) {
                            CoverPicture(picture: viewModel.getMealImageFor(meal.item))
                            
                            // Edit photo button
                            VStack {
                                VerticalSpace(64)

                                HStack {
                                    Spacer()
                                    MedActionWhiteButton(icon: "\u{e914}") {
                                        // TODO: Pop photo picker
                                    }
                                    .padding(.trailing, 25)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            VerticalSpace(250)
                            
                            // Meal Metadata
                            VStack {
                                EditableTextRow("What's the name of this venue?", text: $meal.item.venue.name, onSave:onSave) {
                                    FoodieText(meal.item.venue.name, Colors.TextStaticTextPrimary, weight: .semibold)
                                        .padding(.horizontal, 4)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                EditableTextRow("When did you visit?", text: $meal.item.venue.name, onSave:onSave) {
                                    HStack {
                                        FoodieIcon("\u{e903}", Colors.IconSecondary, padding:0)
                                        FoodieText(meal.item.date.formatted(date:.abbreviated, time:.omitted), Colors.TextStaticTextSecondary, size:12, weight:.medium)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                EditableTextRow("TODO: Location", text: $meal.item.venue.name, onSave:onSave) {
                                    LocationView(location: meal.item.venue.location)
                                }
                                
                                HStack(alignment: .center, spacing: 4) {
                                    EditableTextRow("How would you rate your meal here?", text: $meal.item.venue.name, onSave:onSave){
                                        RatingView(rating:meal.item.rating)
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 6)
                                    }
                                    
                                    
                                    // No rating view
                                    if (meal.item.venue.michelin == nil && meal.item.venue.guideLink?.url == nil) {
                                        EditableTextRow("What was this venue's Michelin rating?", text: $meal.item.venue.name, onSave:onSave) {
                                            HStack {
                                                FoodieText("( not michelin rated )", Colors.TextStaticTextSecondary, size:12, weight:.medium)
                                                    .padding(.vertical, 3)
                                                Spacer()
                                            }
                                        }
                                    } else {
                                        if meal.item.venue.michelin != nil {
                                            EditableTextRow("What was this venue's Michelin rating?", text: $meal.item.venue.name, onSave:onSave) {
                                                MichelinStarView(rating: meal.item.venue.michelin)
                                                    .padding(.horizontal, 4)
                                                    .padding(.vertical, 3)
                                            }
                                        }
                                        if meal.item.venue.guideLink?.url != nil {
                                            HStack {
                                                FoodieIcon("\u{e911}", Colors.TextActionTextAction, padding:0)
                                                GuideLinkView(meal:meal.item)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }
                            
                            VerticalSpace(24)
                            
                            // Meal Notes
                            ViewSection("Overall Notes") {
                                EditableStandaloneTextBox(title: "Overall notes about your meal?", text: $meal.item.notes, onSave:onSave)
                            }
                            
                            VerticalSpace(24)

                            // Meal Cuisine
                            ViewSection("Cuisine") {
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
                            }
                            
                            VerticalSpace(24)

                            // Menu[s]
                            ViewSection("Menus") {
                                EditableImageAndTextBoxRow(title: "Any notes about the menu?", img: meal.item.menu.pictures.first, text: $meal.item.menu.notes, onSave:onSave)
                            }

                            VerticalSpace(24)
                            
                            // Courses
                            ViewSection("Courses") {
                                VStack {
                                    SwipeViewGroup {
                                        ForEach(meal.item.courses, id: \.self) { course in
                                            CourseListCard(course:course)
                                                .padding(.bottom, -2)
                                            
                                        }
                                    }
                                    
                                    BarButtonNav(text:"Add a course", destination: CourseCreateView(mealId: meal.item.id))
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }
                .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 150, trailing: 0))

                BottomFade()

                // Buttons
                BottomButtonContainer(
                    { LargeActionRedButton(icon:"\u{e900}", action: { self.presentationMode.wrappedValue.dismiss() }) },
                    { LargeActionWhiteShareButton(
                        subject: "Notes about my meal at \(meal.item.venue.name) on \(meal.item.date.formatted(date: .complete, time: .omitted))",
                        message: ModelIOService.exportAsString(meal.item),
                        preview: "Notes about my meal at \(meal.item.venue.name) on \(meal.item.date.formatted(date: .complete, time: .omitted))") })
            }
            .onAppear() {
                meal.item = viewModel.getMealFor(meal.item.id) ?? Meal()
            }
            .ignoresSafeArea(.all)
            .navigationBarHidden(true)
        }
    }
    
    
    
    private func onSave() {
        viewModel.saveEditedMealFor(meal.item)
    }
}
