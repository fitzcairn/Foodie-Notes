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
    
    @State var showInvalidVenue:Bool = false;
    @State var doCreate:Bool = false;
    @State var showStartCreate:Bool = false;
    @State var venue:String = "";
    @State var newMeal:Meal = Meal();

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
                    Button(
                        action: {
                            showStartCreate = true;
                            venue = "";
                        },
                        label: {
                            PrimaryButtonSubViews.MealListViewPrimaryNewButtonImage()
                        }
                    )
                }
                .alert("Create a New Meal", isPresented: $showStartCreate) {
                    TextField("Venue name", text: $venue)
                    Button("OK") {
                        if venue.isEmpty {
                            showStartCreate = false
                            showInvalidVenue = true;
                        } else {
                            // Create the new meal
                            newMeal = viewModel.createMealAtVenue(venue)
                            doCreate = true;
                        }
                    }
                    Button("Cancel", role: .cancel) {
                        showStartCreate = false
                    }
                }
                .alert("Invalid Meal Venue", isPresented: $showInvalidVenue) {
                    Text("Please provide the venue name")
                    Button("OK", role: .cancel) {
                        showInvalidVenue = false;
                        showStartCreate = true
                    }
                }
            }
            .navigationDestination(isPresented: $doCreate) {
                MealCreateView(meal:newMeal)
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
