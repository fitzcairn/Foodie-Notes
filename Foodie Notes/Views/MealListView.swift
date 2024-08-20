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
    
    @State var goToMealView:Bool = false;
    @State var venue:String = "";
    @State var sortOrder:AppViewModel.MealSortOrder = .dateDesc;
    @State var filterText:String = "";
    @State var forceAllSwipesClosed:Bool = false;
    @State var isSearching:Bool = false
    
    // Only one new meal can exist at a time.
    @State var newMeal = Meal(venueName: "")
    
    var body: some View {
        let _ = Self._printChanges()
        NavigationStack {
            ZStack {
                VStack {
                    MealListSearchSortMode(filterText:$filterText, sortOrder:$sortOrder, isSearching:$isSearching)
                    
                    list
                }
                .frame(maxWidth: .infinity)
                .background(Colors.BackgroundBgPrimary)
                
                topDivider
                
                BottomFade()
                
                VStack {
                    Spacer()
                    
                    LargeRedButtonTriggeringTextInput(title: "What's the name of the venue?", text:$venue) {
                        newMeal = Meal(venueName: venue)
                        newMeal.rating = 0;
                        viewModel.saveEditedMealFor(newMeal)
                        goToMealView = true;
                    }
                }
                .opacity(isSearching ? 0 : 1)
            }
            .onDisappear() {
                forceAllSwipesClosed.toggle()
            }
            .onChange(of: newMeal) {
            }
            .navigationDestination(isPresented: $goToMealView) {
                MealCreateView(meal:$newMeal)
            }
        }
        .navigationBarHidden(true)
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .inactive {
                viewModel.writeOut()
            }
        }
        .onAppear() {
            // If we came from null screen, go straight to view for the new meal.
            // This is cludgey, but best way I could think of doing this with the right nav stack.
            if let meal = viewModel.nullMeal {
                newMeal = meal;
                viewModel.nullMeal = nil;
                goToMealView.toggle()
            }
        }
    }
    
    var list: some View {
        SwipeViewGroup {
            List {
                ForEach(viewModel.getMeals(filterText: filterText, sortOrder: sortOrder), id: \.self) { meal in
                    MealListCard(meal:meal, forceClose:$forceAllSwipesClosed)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .deleteDisabled(true)
                        .animation(nil, value: 0)
                        .id(meal.pickedImage)
                }
            }
            .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
            .listStyle(.plain)
        }
    }
    
    var topDivider: some View {
        VStack {
            Divider()
                .padding(.top, 16)
            Spacer()
        }
    }
}
