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

    // Only one new meal can exist at a time.
    @State var newMeal = Meal(venueName: "")
    
    var body: some View {
        let _ = Self._printChanges()
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
                    
                    LargeRedButtonTriggeringTextInput(title: "What's the name of the venue?", text:$venue) {
                        newMeal = Meal(venueName: venue)
                        newMeal.rating = 0;
                        viewModel.saveEditedMealFor(newMeal)
                        goToMealView = true;
                    }
                }
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
                        .id(meal.pickedImage)
                }
            }
            .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
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
