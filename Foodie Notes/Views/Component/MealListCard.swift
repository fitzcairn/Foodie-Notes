//
//  MealListCard.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/6/24.
//

import SwiftUI

struct MealListCard: View {
    @EnvironmentObject var viewModel:AppViewModel;
    @State var viewState = CGSize(width: 0, height: 50)

    let meal:Meal;

    struct Constants {
        static let FillStaticFillPrimary: Color = .white
        static let Spacing1: CGFloat = 8
        static let BorderHairline: CGFloat = 1
        static let Spacing2: CGFloat = 12
        static let Spacing3: CGFloat = 16
        static let ShadowPositioningNone: CGFloat = 0
        static let ShadowPositioningMd: CGFloat = 8
        static let ShadowBlurLg: CGFloat = 16
        static let ShadowMed: Color = Color(red: 0.53, green: 0.33, blue: 0.11).opacity(0.06)
        static let ShadowBlurMd: CGFloat = 8
        static let ShadowEdge: Color = Color(red: 0.53, green: 0.33, blue: 0.11).opacity(0.04)
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            NavigationLink(destination: MealView(meal: meal)) { EmptyView() }.opacity(0.0)
            
            HStack {
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
            }
            .background(.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: Constants.ShadowMed, radius: Constants.ShadowBlurLg / 2, x: Constants.ShadowPositioningNone, y: Constants.ShadowPositioningMd)
        .shadow(color: Constants.ShadowEdge, radius: Constants.ShadowBlurMd / 2, x: Constants.ShadowPositioningNone, y: Constants.ShadowPositioningNone)
        .padding(.vertical, -1)
        //.padding(.horizontal, -20)
        /*.addSwipeAction(edge: .trailing) { // <== HERE! choose .trailing or .leading
            Button {
                print("remove")
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.white)
            }
            .frame(width: 60, height: 50, alignment: .center)
            .contentShape(Rectangle())
            .background(Color.red)
            
            Button {
                print("Inform")
            } label: {
                Image(systemName: "bell.slash.fill")
                    .foregroundColor(.white)
            }
            .frame(width: 60, height: 50, alignment: .center)
            .background(Color.blue)
            
        }*/
    }
}
