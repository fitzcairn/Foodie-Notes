//
//  NullView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/20/24.
//

import SwiftUI

struct NullView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var viewModel:AppViewModel;
    
    @State private var showTopText:Bool = false;
    @State private var showBottomText:Bool = false;
    @State private var venue:String = "";
    
    // Only one new meal can exist at a time.
    @State private var newMeal = Meal(venueName: "")
    
    var body: some View {
        let _ = Self._printChanges()
        ZStack {
            Color(Colors.BackgroundBgPrimary)
            
            VStack {
                Spacer()
                
                if showTopText {
                    VStack {
                        Image(uiImage: UIImage(named: "food-icons")!)
                            .frame(width: 42, height: 32, alignment: .center)
                        VerticalSpace(12)
                        FoodieText("Your culinary adventures await.", Colors.TextStaticTextSecondary, size:16, weight:.semibold)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 48)
                    }
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
                
                
                Spacer()
            }
            
            VStack {
                Spacer()
                
                if showBottomText {
                    FoodieText("Add a Meal", Colors.TextActionTextAction, size:18, weight:.bold)
                        .multilineTextAlignment(.center)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
                
                LargeRedButtonTriggeringTextInput(title: "What's the name of the venue?", text:$venue) {
                    newMeal = Meal(venueName: venue)
                    newMeal.rating = 0;
                    viewModel.saveEditedMealFor(newMeal)
                    viewModel.nullMeal = newMeal;
                    viewModel.state = .list
                }
                .padding(.top, 4)
                .padding(.bottom, 32)
            }
        }
        .ignoresSafeArea(.all)
        .onAppear() {
            withAnimation(.easeInOut(duration: 0.9)) {
                showTopText.toggle()
            } completion: {
                withAnimation(.easeInOut(duration: 0.7)) {
                    showBottomText.toggle()
                }
            }
        }
    }
}
