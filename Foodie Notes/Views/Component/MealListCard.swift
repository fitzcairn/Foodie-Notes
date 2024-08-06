//
//  MealListCard.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/6/24.
//

import SwiftUI
import SwipeActions

struct MealListCard: View {
    @EnvironmentObject var viewModel:AppViewModel;
    @State var deleted:Bool = false;

    let meal:Meal;
       
    
    var body: some View {
        if deleted {
            EmptyView()
        } else {
            ZStack(alignment: .leading) {
                NavigationLink(destination: MealView(meal: meal)) { EmptyView() }.opacity(0.0)
                
                SwipeView {
                    HStack {
                        
                        PhotoSubViews.PhotoShowView(picture:viewModel.getMealImageFor(meal))
                        
                        VStack(alignment: .leading) {
                            // Venue name
                            FoodieText(meal.venue.name, Colors.TextStaticTextPrimary)
                                .padding(4)
                            
                            // Date and rating
                            HStack {
                                FoodieIcon("\u{e903}", Colors.IconSecondary, padding:0)
                                
                                FoodieText(meal.date.formatted(date:.abbreviated, time:.omitted), Colors.TextStaticTextSecondary, size:12, weight:.medium)
                                Spacer()
                                RatingView(rating:meal.rating)
                            }

                            // Location
                            LocationView(location: meal.venue.location)

                            // Michelin link and star rating.
                            //MichelinStarView(rating: meal.venue.michelin)

                                                        
                            /* TODO: move this.
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
                        }
                        .padding(.vertical, 8)
                        .padding(.leading, 8)
                        .padding(.trailing, 16)
                    }
                    .background(.white)
                    
                } trailingActions: { _ in
                    SwipeAction(
                        action: {
                            deleted = true;
                            viewModel.removeMeal(meal.id);
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
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
            .shadow(color: Colors.ShadowEdge, radius: 8, x: 0, y: 0)
            .padding(.vertical, -1)
            .padding(.horizontal, 4)
        }
    }
}
