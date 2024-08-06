//
//  MealListView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI


// This is effectively the main view.
struct MealListView: View {
    private struct Colors {
        static let BackgroundBgPrimary: Color = Color(red: 1, green: 0.99, blue: 0.96)
        static let ShadowHigh: Color = Color(red: 0.53, green: 0.33, blue: 0.11).opacity(0.08)
        static let ShadowEdge: Color = Color(red: 0.53, green: 0.33, blue: 0.11).opacity(0.04)
        static let Delete: Color = Color(red: 0.92, green: 0.43, blue: 0.29)
    }
    

    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var viewModel:AppViewModel;
    
    @State var showInvalidVenue:Bool = false;
    @State var doCreate:Bool = false;
    @State var showStartCreate:Bool = false;
    @State var venue:String = "";
    @State var newMeal:Meal = Meal();


    
    var body: some View {
        NavigationStack {


            /*Text("\u{e921}")
                .font(
                    Font.custom("foodie-icons", size: 64)
                        .weight(.heavy)
                )*/
            
            
            ZStack {
                VStack {
                    list
                }
                .frame(maxWidth: .infinity)
                .background(Colors.BackgroundBgPrimary)

                topFade
                
                bottomFade
                
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
    
    var list: some View {
        List {
            ForEach(viewModel.getMeals(), id: \.self) { meal in
                MealListCard(meal:meal)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            // Call function to delete name
                            // It's equivalent to using the onDelete modifier
                        } label: {
                            Label("penis", systemImage: "trash.fill")
                        }
                        .tint(.red)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            .onDelete() { at in
                remove(at:at, meals:viewModel.getMeals())
            }
        }
        .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
        .padding(.horizontal, 40)
        .id(UUID())
        .listStyle(.plain)
        .navigationBarBackButtonHidden()
        .navigationBarItems(
            leading: StyledTitleText(ViewTitle.listMeals)
        )
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
    
    var bottomFade: some View {
        VStack() {
            Spacer()
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 1, green: 0.98, blue: 0.96).opacity(0), location: 0.00),
                    Gradient.Stop(color: Color(red: 1, green: 0.99, blue: 0.96), location: 1.00),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height:120)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
            
    func remove(at offsets: IndexSet, meals:[Meal]) {
        for (index, meal) in meals.enumerated() {
            if offsets.contains(index) {
                viewModel.removeMeal(meal.id);
            }
        }
    }
}


/*
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
 */
