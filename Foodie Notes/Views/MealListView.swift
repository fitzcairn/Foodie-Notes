//
//  MealListView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI
import SwipeActions


// This is effectively the main view.
struct MealListView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var viewModel:AppViewModel;
    
    @State var showInvalidVenue:Bool = false;
    @State var doCreate:Bool = false;
    @State var showStartCreate:Bool = false;
    @State var venue:String = "";
    @State var newMeal:Meal = Meal();
    @State var sortOrder:AppViewModel.MealSortOrder = .dateDesc;
    @State var filterText:String = "";
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    MealListSearchSortMode(filterText:$filterText, sortOrder:$sortOrder)

                    list
                }
                .frame(maxWidth: .infinity)
                .background(Colors.BackgroundBgPrimary)
                
                topFade
                
                BottomFade()
                
                VStack {
                    Spacer()
                    
                    LargeActionRedButton(icon: "\u{e91f}", action: {
                        showStartCreate = true;
                        venue = "";
                    })
                }
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
            .navigationDestination(isPresented: $doCreate) {
                MealCreateView(meal:newMeal)
            }
        }
        .navigationBarHidden(true)
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
    
    var list: some View {
        SwipeViewGroup {
            List {
                ForEach(viewModel.getMeals(filterText: filterText, sortOrder: sortOrder), id: \.self) { meal in
                    MealListCard(meal:meal)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .deleteDisabled(true)
                        .animation(nil, value: 0)
                }
            }
            .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
            //.id(UUID()) <-- caused a lot of unnecessary list renders.
            .listStyle(.plain)
        }
    }
    
    var topFade: some View {
        VStack {
            Rectangle()
                .frame(height:0)
                .padding(.bottom, 1)
                .background(Colors.BackgroundBgPrimary)
                .shadow(color: Colors.ShadowHigh, radius: 8, x: 0, y: 16)
                .shadow(color: Colors.ShadowEdge, radius: 2, x: 0, y: 1)
            Spacer()
        }
    }
}
