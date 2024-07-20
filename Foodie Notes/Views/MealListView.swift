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
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var viewModel:AppViewModel;
    
    let saveAction: () -> Void
    
    var progressView : some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red:1, green:0.988, blue:0.914), Color.white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            GeometryReader { gp in
                ZStack {
                    Image("icon")
                        .resizable()
                        .frame(width:300, height:300)
                        .padding(.vertical, 10)
                        .alignmentGuide(VerticalAlignment.center, computeValue: { $0[.bottom] })
                        .position(x: gp.size.width / 2, y: gp.size.height / 2)
                    ProgressView()
                        .alignmentGuide(VerticalAlignment.center, computeValue: { $0[.top] - 16 })
                }
            }
        }
    }
    
    var loadingView: some View {
        progressView
        .task {
            do {
                try await viewModel.fromLoad(model:ModelIOService.load())
            } catch {
                fatalError(error.localizedDescription)
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
                                        MichelinSubViews.MichelinNameView(name: meal.venue.name, rating: meal.venue.michelin)
                                            .bold()
                                        Spacer()
                                        RatingSubViews.RatingView(rating:meal.rating)
                                    }
                                    Text(viewModel.getMealFor(meal.id)!.notes)
                                        .foregroundColor(.gray)
                                    if (meal.venue.city != nil) {
                                        VenueSubViews.LocationView(venue: meal.venue)
                                    }
                                    if (!meal.cuisines.isEmpty) {
                                        HStack {
                                            Image(systemName: "fork.knife")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 18)
                                                .foregroundColor(Color.gray)
                                                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                                                .padding(.trailing, 3)
                                            
                                                .frame(width:18, height: 18)
                                                .background(Color.red)
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
                saveAction()
            }
        }
    }
    
    var body: some View {
        switch viewModel.state {
            case .loading:
                loadingView
            case .splash, .list:
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
