//
//  MealView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI
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
                                    
                                    // TODO: change to image picker.
                                    ImageShow(src: .picture(viewModel.getMealImageFor(meal.item)))
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
                                
                                EditableDateView("When did you visit?", date: $meal.item.date, onSave:onSave) {
                                    HStack {
                                        FoodieIcon("\u{e903}", Colors.IconSecondary, padding:0)
                                        FoodieText(meal.item.date.formatted(date:.abbreviated, time:.omitted), Colors.TextStaticTextSecondary, size:12, weight:.medium)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                EditableLocationView("Where was this venue?", location: $meal.item.venue.location, venueName: $meal.item.venue.name, onSave:onSave)
                                
                                HStack(alignment: .center, spacing: 4) {
                                    EditableRatingView("How would you rate your meal here?", rating: $meal.item.rating, onSave:onSave){
                                        RatingView(rating:meal.item.rating)
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 6)
                                    }
                                    
                                    
                                    if (meal.item.venue.michelin == nil || meal.item.venue.michelin! == .none) {
                                        // No rating view
                                        EditableMichelinRatingView("What was this venue's Michelin rating?", rating: $meal.item.venue.michelin, onSave:onSave) {
                                            HStack {
                                                FoodieText("( not michelin rated )", Colors.TextStaticTextSecondary, size:12, weight:.medium)
                                                    .padding(.vertical, 3)
                                                Spacer()
                                            }
                                        }
                                    } else {
                                        // Rating
                                        EditableMichelinRatingView("What was this venue's Michelin rating?", rating: $meal.item.venue.michelin, onSave:onSave) {
                                            MichelinStarView(rating: meal.item.venue.michelin)
                                                .padding(.horizontal, 4)
                                                .padding(.vertical, 3)
                                                .frame(minWidth: 64, maxWidth: 64, alignment: .center)
                                        }
                                        
                                        // Guide link/link fetch
                                        HStack {
                                            HStack(alignment: .center, spacing: 4) {
                                                FoodieIcon("\u{e911}", Colors.TextActionTextAction, padding:0)
                                                GuideLinkView(meal:meal.item)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(12)
                                            .background(Colors.FillStaticFillPrimary)
                                            .cornerRadius(8)
                                            .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
                                            .shadow(color: Colors.ShadowEdge, radius: 4, x: 0, y: 0)
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
                                EditableCuisineView(title: "What cuisine[s] were served for this meal?", cuisines: $meal.item.cuisines, onSave:onSave);
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
