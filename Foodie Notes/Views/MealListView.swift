//
//  MealListView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI

// This is effectively the main view.
struct MealListView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var viewModel:AppViewModel;

    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(viewModel.getMeals(), id: \.self) { meal in
                        HStack {
                            PhotoSubViews.PhotoShowView(picture:viewModel.getMealImageFor(meal))
                            NavigationLink(destination: MealView(meal: meal)) {
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
                                .padding(8)
                            }
                        }
                    }
                    .onDelete() { at in
                        remove(at:at, meals:viewModel.getMeals())
                    }
                }
                .id(UUID())
                .listStyle(.plain)
                .navigationBarBackButtonHidden()
                .navigationBarItems(
                    leading: StyledTitleText(ViewTitle.listMeals)
                )
                VStack {
                    Spacer()
                    NavigationLink(
                        destination: MealCreateView()
                    )
                    {
                        PrimaryButtonSubViews.MealListViewPrimaryNewButtonImage()
                    }
                }
            }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .inactive {
                Task {
                    do {
                        try await ModelIOService.saveAppModel(model: viewModel.model)
                    } catch {
                        // Blow up
                        fatalError(error.localizedDescription)
                    }
                }
            }
        }
    }
            
    func remove(at offsets: IndexSet, meals:[Meal]) {
        for (index, meal) in meals.enumerated() {
            if offsets.contains(index) {
                viewModel.removeMeal(meal.id);
            }
        }
    }
}
