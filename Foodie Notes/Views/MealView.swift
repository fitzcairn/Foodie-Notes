//
//  MealView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI
import SwipeActions


struct MealView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel:AppViewModel;
    
    @ObservedObject private var meal:WrappedStruct<Meal>;
    @State var goToCourseView:Bool = false;
    @State var courseName:String = "";
    
    // Only one new course can exist at a time.
    @State var newCourse:Course;
    
    init(meal:Meal) {
        _meal = ObservedObject(wrappedValue: WrappedStruct(withItem:meal))
        _newCourse = State.init(initialValue: Course(mealId: meal.id, name: ""))
    }
    
    var body: some View {
        let _ = Self._printChanges()
        ZStack(alignment: .bottom) {
            Color(Colors.BackgroundBgPrimary)
            
            ScrollView {
                ZStack(alignment: .top) {
                    ZStack(alignment: .top) {
                        CoverPicture(picture: viewModel.getMealImageFor(meal.item))
                            .id(viewModel.getMealImageFor(meal.item))
                        
                        // Edit photo button
                        VStack {
                            VerticalSpace(64)
                            
                            HStack {
                                Spacer()
                                SingleImagePickerButton(picture:$meal.item.pickedImage, onSave:onSave)
                                    .padding(.trailing, 25)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        VerticalSpace(250)
                        
                        // Meal Metadata
                        VStack {
                            EditableTextRow(title: "What's the name of this venue?", text: $meal.item.venue.name, onSave:onSave) {
                                FoodieText(meal.item.venue.name, Colors.TextStaticTextPrimary, weight: .semibold)
                                    .padding(.horizontal, 4)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            EditableDateView(title: "When did you visit?", date: $meal.item.date, onSave:onSave) {
                                HStack {
                                    FoodieIcon("\u{e903}", Colors.IconSecondary, padding:0)
                                    FoodieText(meal.item.date.formatted(date:.abbreviated, time:.omitted), Colors.TextStaticTextSecondary, size:12, weight:.medium)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            EditableLocationView(title: "Where was this venue?", location: $meal.item.venue.location, venueName: $meal.item.venue.name, onSave:onSave)
                            
                            HStack(alignment: .center, spacing: 4) {
                                EditableRatingView(title: "How would you rate your meal here?", rating: $meal.item.rating, onSave:onSave) {
                                    RatingView(rating:meal.item.rating)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 6)
                                }
                                
                                if (meal.item.venue.michelin == .none) {
                                    // No rating view
                                    EditableMichelinRatingView(title: "What was this venue's Michelin rating?", rating: $meal.item.venue.michelin, onSave:onSave) {
                                        HStack {
                                            FoodieText("( not michelin rated )", Colors.TextStaticTextSecondary, size:12, weight:.medium)
                                                .padding(.vertical, 4)
                                            Spacer()
                                        }
                                    }
                                } else {
                                    // Rating
                                    EditableMichelinRatingView(title: "What was this venue's Michelin rating?", rating: $meal.item.venue.michelin, onSave:onSave) {
                                        MichelinStarView(rating: meal.item.venue.michelin)
                                            .padding(.horizontal, 4)
                                            .padding(.vertical, 3)
                                            .frame(minWidth: 64, maxWidth: 64, alignment: .center)
                                    }
                                    
                                    // Guide link/link fetch
                                    HStack {
                                        GuideLinkView(venue:$meal.item.venue, onSave:onSave)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(12)
                                            .background(Colors.FillStaticFillPrimary)
                                            .cornerRadius(8)
                                            .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
                                            .shadow(color: Colors.ShadowEdge, radius: 4, x: 0, y: 0)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .id(meal.item.venue)
                        }
                        
                        VerticalSpace(24)
                        
                        // Meal Notes
                        ViewSection("Overall Notes") {
                            EditableStandaloneTextBox(title: "Overall notes about your meal?", addTitle: "Add notes", text: $meal.item.notes, onSave:onSave)
                        }
                        
                        VerticalSpace(24)
                        
                        // Meal Cuisine
                        ViewSection("Cuisine") {
                            EditableCuisineView(title: "What cuisine[s] were served for this meal?", cuisines: $meal.item.cuisines, onSave:onSave)
                        }
                        
                        VerticalSpace(24)
                        
                        // Menu[s]
                        ViewSection("Menus") {
                            EditableImageAndTextBoxRow(title: "Any notes about the menu?", addTitle: "Add menu notes", pictures: $meal.item.menu.pictures, text: $meal.item.menu.notes, onSave:onSave)
                        }
                        
                        VerticalSpace(24)
                        
                        // Courses
                        ViewSection("Courses") {
                            VStack {
                                SwipeViewGroup {
                                    ForEach(viewModel.getMealFor(meal.item.id)!.courses, id: \.self) { course in
                                        CourseListCard(course:course)
                                            .padding(.bottom, -2)
                                    }
                                }
                                
                                BarButtonTriggeringTextInput(title: "What's the name of the course?", addTitle: "Add a course", text:$courseName) {
                                    newCourse = Course(mealId: meal.item.id, name: courseName)
                                    meal.item.courses.append(newCourse)
                                    onSave()
                                    goToCourseView = true;
                                }
                                .navigationDestination(isPresented: $goToCourseView) {
                                    NavigationLazyView(CourseCreateView(course:$newCourse))
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
            .onAppear() {
                reload()
            }
            
            
            .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 150, trailing: 0))
            
            BottomFade()
            
            // Buttons
            BottomButtonContainer() {
                LargeActionRedButton(icon:"\u{e900}") {
                    self.presentationMode.wrappedValue.dismiss()
                }
                
                Spacer()
                
                LargeActionWhiteShareButton(
                    subject: "Notes about my meal at \(meal.item.venue.name) on \(meal.item.date.formatted(date: .complete, time: .omitted))",
                    message: ModelIOService.exportAsString(meal.item),
                    preview: "Notes about my meal at \(meal.item.venue.name) on \(meal.item.date.formatted(date: .complete, time: .omitted))")
            }
        }
        .ignoresSafeArea(.all)
        .navigationBarHidden(true)
    }
    
    private func reload() {
        if let savedMeal = viewModel.getMealFor(meal.item.id) {
            meal.item = savedMeal
            print("Refreshing meal \(savedMeal.id)")
        }
    }
    
    private func onSave() {
        print("saving Meal \(meal.item.id)")
        viewModel.saveEditedMealFor(meal.item)
    }
}
