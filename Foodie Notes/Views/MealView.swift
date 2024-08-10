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
    
    @State private var shareText:String? = "";
    
    init(meal:Meal) {
        self.meal = WrappedStruct(withItem:meal)
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
                            VerticalSpace(180)
                            
                            // Meal Metadata
                            VStack {
                                EditableTextRow("What's the name of this venue?") {
                                    FoodieText(meal.item.venue.name, Colors.TextStaticTextPrimary, weight: .semibold)
                                        .padding(.horizontal, 4)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                EditableTextRow("When did you visit?") {
                                    HStack {
                                        FoodieIcon("\u{e903}", Colors.IconSecondary, padding:0)
                                        FoodieText(meal.item.date.formatted(date:.abbreviated, time:.omitted), Colors.TextStaticTextSecondary, size:12, weight:.medium)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                EditableTextRow("TODO: Location") {
                                    LocationView(location: meal.item.venue.location)
                                }
                                
                                HStack(alignment: .center, spacing: 4) {
                                    EditableTextRow("How would you rate your meal here?"){
                                        RatingView(rating:meal.item.rating)
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 6)
                                    }
                                    
                                    
                                    // No rating view
                                    if (meal.item.venue.michelin == nil && meal.item.venue.guideLink?.url == nil) {
                                        EditableTextRow("What was this venue's Michelin rating?") {
                                            HStack {
                                                FoodieText("( not michelin rated )", Colors.TextStaticTextSecondary, size:12, weight:.medium)
                                                    .padding(.vertical, 3)
                                                Spacer()
                                            }
                                        }
                                    } else {
                                        if meal.item.venue.michelin != nil {
                                            EditableTextRow("What was this venue's Michelin rating?") {
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
                                EditableStandaloneTextBox(title: "Overall notes about your meal?", text: "this is a note")
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
                                HStack(alignment: .top, spacing: 10) {
                                    HStack(alignment: .center) {
                                        
                                        // TODO: Replace with menu photo
                                        MealListPicture(picture:viewModel.getMealImageFor(meal.item))
                                            .padding(4)
                                            .frame(minWidth: 64, maxWidth: 64, minHeight:64, maxHeight: .infinity, alignment: .leading)
                                            .clipped()
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                        
                                    }
                                    
                                    EditableTextBoxRow(title: "Any notes about the menu?", text: "this is a a menu description")
                                }
                                .background(Colors.FillStaticFillPrimary)
                                .cornerRadius(8)
                                .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
                                .shadow(color: Colors.ShadowEdge, radius: 4, x: 0, y: 0)
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
                                    
                                    // Add Course button
                                    // TODO: Move to a shared view component, this is used elsewhere.
                                    /*HStack {
                                        NavigationLink(destination: CourseCreateView(mealId: meal.item.id)) {
                                            HStack {
                                                FoodieIcon("\u{e91f}", Colors.BorderActionBorderAction, padding:0)
                                                Spacer()
                                                    .frame(width:8)
                                                FoodieText("Add a course", Colors.TextActionTextAction, size:14, weight:.semibold)
                                            }
                                            .frame(maxWidth: .infinity, minHeight: 64, maxHeight: 64, alignment: .center)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .inset(by: 0.75)
                                                    .stroke(Colors.BorderStaticBorderSecondary, lineWidth: 1.5)
                                            )
                                        }
                                        .buttonStyle(AddCourseButtonStyle())
                                    }*/
                                    
                                    
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
    
    private struct AddCourseButtonStyle: ButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .background(configuration.isPressed ? Colors.FillStaticFillSecondary : Colors.BackgroundBgPrimary)
                .cornerRadius(8)
        }
    }
}
