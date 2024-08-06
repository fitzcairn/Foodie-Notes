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
                            HStack {
                                MichelinSubViews.MichelinNameView(name: meal.venue.name, rating: meal.venue.michelin)
                                Spacer()
                                RatingSubViews.RatingView(rating:meal.rating)
                            }
                            
                            Text(viewModel.getMealFor(meal.id)!.date.formatted(date:.complete, time:.omitted))
                                .foregroundColor(.gray)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(1)
                                .padding(.top, 4)
                            
                            LocationView(location: meal.venue.location)
                            
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
                            }
                        }
                    }
                    .background(.white)
                    
                } trailingActions: { _ in
                    SwipeAction(
                        action: {
                            deleted = true;
                            viewModel.removeMeal(meal.id);
                        },
                        label: { highlight in
                            Text("\u{e928}")
                                .font(Font.custom("foodie-icons", size: 28))
                                .foregroundColor(.white)
                        },
                        background: { highlight in
                            Rectangle()
                                .foregroundColor(Colors.Delete)
                        })
                    .allowSwipeToTrigger(false)
                }
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
            .padding(.horizontal, 10)
        }
    }
}
