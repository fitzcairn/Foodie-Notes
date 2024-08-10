//
//  MealListCard.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/6/24.
//

import SwiftUI
import SwipeActions
import Combine

struct MealListCard: View {
    @EnvironmentObject var viewModel:AppViewModel;
    @State var deleted:Bool = false;
    @State var showConfirm:Bool = false;
    @State var swipeState:SwipeContext?;
    
    let meal:Meal;
    
    
    var body: some View {
        if deleted {
            EmptyView()
        } else {
            ZStack(alignment: .leading) {
                NavigationLink(destination: MealView(meal: meal)) { EmptyView() }.opacity(0.0)
                
                SwipeView {
                    HStack {
                        MealListPicture(picture:viewModel.getMealImageFor(meal))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .padding(4)
                        
                        VStack(alignment: .leading) {
                            // Venue name
                            FoodieText(meal.venue.name, Colors.TextStaticTextPrimary)
                                .padding(.bottom, 2)
                                .padding(.horizontal, 4)
                            
                            // Date and rating
                            HStack {
                                FoodieIcon("\u{e903}", Colors.IconSecondary, padding:0)
                                FoodieText(meal.date.formatted(date:.abbreviated, time:.omitted), Colors.TextStaticTextSecondary, size:12, weight:.medium)
                                Spacer()
                                RatingView(rating:meal.rating)
                            }
                            
                            // Location
                            LocationView(location: meal.venue.location)
                            
                            // Guide link and star rating.
                            if (meal.venue.michelin != nil || meal.venue.guideLink?.url != nil) {
                                HStack {
                                    if meal.venue.guideLink?.url != nil {
                                        FoodieIcon("\u{e911}", Colors.TextActionTextAction, padding:0)
                                        GuideLinkView(meal:meal)
                                    }
                                    Spacer()
                                    if meal.venue.michelin != nil {
                                        MichelinStarView(rating: meal.venue.michelin)
                                    }
                                }
                                .frame(height:10)
                            }
                        }
                        .padding(.vertical, 4)
                        .padding(.leading, 4)
                        .padding(.trailing, 16)
                    }
                    .background(.white)
                    
                } trailingActions: { context in
                    SwipeAction(
                        action: {
                            showConfirm.toggle()
                            swipeState = context;
                        },
                        label: { highlight in
                            FoodieIcon("\u{e928}", .white)
                        },
                        background: { highlight in
                            Rectangle()
                                .foregroundColor(Colors.Delete)
                        })
                    .swipeActionLabelFixedSize(true)
                    .allowSwipeToTrigger(false)
                }
                .swipeActionWidth(72)
                .swipeActionsVisibleEndPoint(60)
                .swipeActionsStyle(.mask)
                .swipeActionCornerRadius(0)
                .swipeSpacing(0)
                .swipeActionsMaskCornerRadius(0)
                .swipeMinimumDistance(20)
                .swipeReadyToExpandPadding(20)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
            .shadow(color: Colors.ShadowEdge, radius: 8, x: 0, y: 0)
            .padding(.vertical, -8)
            .padding(.horizontal, 4)
            .alert("Delete Meal?",
                   isPresented: $showConfirm,
                   actions: {
                Button("No", role: .cancel) {
                    if let context = swipeState {
                        context.state.wrappedValue = .closed
                    }
                    showConfirm.toggle()
                }
                Button ("Yes", role: .destructive) {
                    deleted = true;
                    viewModel.removeMeal(meal.id);
                }
            })
        }
    }
}
