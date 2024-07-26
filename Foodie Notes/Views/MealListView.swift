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
    
    @State var pictures:[Picture] = []
    @StateObject var recModel:AsyncLabelRecognitionViewModel = AsyncLabelRecognitionViewModel()
        
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
                try await viewModel.fromLoad(model:ModelIOService.loadAppModel())
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    // Alternate listview for testing wine recognition.
    var listView: some View {
        ScrollView {
            HStack {
                PhotoSubViews.PhotoPickerButton(pictures: $pictures, limit: 1)
            }

            ForEach(pictures, id: \.self) { picture in
                VStack {
                    PhotoSubViews.PhotoView(img:picture.photo!.full)
                        .frame(height:500)

                    AsyncRecognizedWineLabelView(
                        source: recModel,
                        img: picture.photo!.full,
                        progressContent: {
                            HStack {
                                ProgressView()
                                    .frame(width:PhotoDimensions.photoWidth, height: PhotoDimensions.photoHeight)
                            }
                        },
                        photoContent: {
                            let image = recModel.subject ?? UIImage()
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(height:500)
                            Text((recModel.text ?? []).joined(separator: "\n"))
                                .font(.system(size:20, weight: .regular))
                            if let link = recModel.link, let name = recModel.name {
                                Link(name, destination:link)
                                    .font(.system(size:20, weight: .regular))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .lineLimit(1)
                            }
                        }
                    )
                }
            }
        }
     }
    
    /*var listView: some View {
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
                saveAction()
            }
        }
    }*/
    
    
    var body: some View {
        switch viewModel.state {
            case .loading:
                loadingView
            case .splash, .list:
                listView
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
