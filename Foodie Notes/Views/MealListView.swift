//
//  MealListView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI

// View the list of meals.
// This is effectively the main view.
struct MealListView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var viewModel:AppViewModel;
    
    @State var needRefresh:Bool = true;
    let saveAction: () -> Void
    
    var splashView: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red:1, green:0.988, blue:0.914), Color.white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack() {
                Text("Happy Birthday, Ying!")
                    .font(Font.custom("ChalkboardSE-Bold", size: 30))
                    .padding(.top, 40)
                    .foregroundColor(.black)
                
                Image("icon")
                    .resizable()
                    .frame(width:300, height:300)
                    .padding(.vertical, 10)
                
                Text("Love always,\nSteve")
                    .multilineTextAlignment(.center)
                    .font(Font.custom("ChalkboardSE-Bold", size: 20))
                    .padding(.bottom, 60)
                    .foregroundColor(.black)
                
                Text("Tap anywhere to continue...")
                    .font(.system(size:14))
                    .foregroundColor(.black)
                    .italic()
                    .padding(.bottom, 20)
            }
        }
        .onTapGesture {
            viewModel.model.showSplash = false;
            viewModel.state = .list
        }
        .onChange(of: scenePhase) {
            if scenePhase == .inactive {
                saveAction()
            }
        }
    }
    
    var loadingView: some View {
        VStack {
            ProgressView()
        }
        .task {
            do {
                try await viewModel.load()
            } catch {
                //fatalError(error.localizedDescription)
            }
        }
    }
    
    var listView: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(viewModel.getMeals(), id: \.self) { meal in
                        HStack {
                            PhotoSubViews.PhotoShowView(picture:viewModel.getMealImageFor(meal))
                            NavigationLink(destination: MealView(meal: meal)) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(meal.venue.name)
                                            .bold()
                                        Spacer()
                                        RatingSubViews.RatingView(rating:meal.rating)
                                    }
                                    Text(viewModel.getMealFor(meal.id)!.notes)
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                .padding(8)
                            }
                        }
                    }
                    .onDelete() { at in
                        remove(at:at, meals:viewModel.getMeals())
                    }
                }
                .listStyle(.plain)
                .navigationBarBackButtonHidden()
                .navigationBarItems(
                    leading: Text("Meals")
                        .font(.system(size:36, weight: .bold))
                )
                VStack {
                    Spacer()
                    NavigationLink(destination: MealCreateOrEditView(title: "Create New Meal")) {
                        PrimaryNewButtonImage()
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        viewModel.beginCreatingNewMeal()
                    })
                }
            }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .inactive {
                saveAction()
            }
        }
    }
    
    var body: some View {
        switch viewModel.state {
            case .loading:
                loadingView
            case .splash:
                splashView
            case .list:
                listView
        }
    }
            
    func remove(at offsets: IndexSet, meals:[Meal]) {
        print(offsets);
        for (index, meal) in meals.enumerated() {
            if offsets.contains(index) {
                viewModel.removeMeal(meal.id);
            }
        }
    }
}
