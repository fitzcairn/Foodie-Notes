//
//  MealView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/29/24.
//

import SwiftUI
import SwipeActions
import UniformTypeIdentifiers


struct MealView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel:AppViewModel;
    
    @ObservedObject private var meal:WrappedStruct<Meal>;
    @State private var goToCourseView:Bool = false;
    @State private var courseName:String = "";
    @State private var newMenu:PicturesAndNotes = PicturesAndNotes();
    @State private var newCourse:Course;
    @State private var forceAllSwipesClosed:Bool = false;
    @State private var draggingIndex: Int?

    
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
                    
                    CoverImageAndPickerView(
                        picture: Binding<Picture?> (
                            get: { viewModel.getMealImageFor(meal.item) },
                            set: { meal.item.pickedImage = $0 }
                        ),
                        onSave:onSave)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        VerticalSpace(250)
                        
                        // Meal Metadata
                        VStack(spacing:4) {
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
                            
                            EditableLocationView(title: "Where was this venue?", location: $meal.item.venue.location, venueName: $meal.item.venue.name, showLinkIcon:true, onSave:onSave)
                            
                            
                            
                            HStack(alignment: .center, spacing: 4) {
                                if (meal.item.venue.michelin == .unselected) {
                                    // No rating view
                                    EditableMichelinRatingView(title: "What was this venue's Michelin rating?", rating: $meal.item.venue.michelin, onSave:onSave) {
                                        HStack {
                                            FoodieText("Add Michelin Rating", Colors.TextActionTextAction, size:12, weight:.medium)
                                                .padding(.vertical, 4)
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                    }
                                    
                                    EditableRatingView(title: "How would you rate your meal here?", rating: $meal.item.rating, onSave:onSave) {
                                        RatingView(rating:meal.item.rating)
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 4)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                    }
                                } else {
                                    // Rating
                                    EditableMichelinRatingView(title: "What was this venue's Michelin rating?", rating: $meal.item.venue.michelin, onSave:onSave) {
                                        MichelinStarView(rating: meal.item.venue.michelin)
                                            .padding(.leading, 4)
                                            .padding(.trailing, 12)
                                            .padding(.vertical, 3)
                                        
                                        if meal.item.venue.michelin != .none {
                                            GuideLinkView(venue:$meal.item.venue, onSave:onSave, iconOnRight:true)
                                        } else {
                                            FoodieText("Not Michelin rated", Colors.TextStaticTextSecondary, size:12, weight:.medium)
                                        }
                                    }
                                    
                                    
                                    EditableRatingView(title: "How would you rate your meal here?", rating: $meal.item.rating, onSave:onSave) {
                                        RatingView(rating:meal.item.rating)
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 4)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .id(meal.item.venue)
                        }
                        
                        VerticalSpace(16)
                        
                        // Meal Notes
                        ViewSection("Overall Notes") {
                            EditableStandaloneTextBox(title: "Overall notes about your meal?", addTitle: "Add Notes", text: $meal.item.notes, onSave:onSave)
                        }
                        
                        VerticalSpace(16)
                        
                        // Meal Cuisine
                        ViewSection("Cuisine") {
                            EditableCuisineView(title: "What cuisine[s] were served for this meal?", cuisines: $meal.item.cuisines, onSave:onSave)
                        }
                        
                        VerticalSpace(16)
                        
                        // Menu[s]
                        ViewSection("Menus") {
                            SwipeViewGroup {
                                ForEach(Array(zip(meal.item.menus.indices, meal.item.menus)), id: \.0) { index, menu in
                                    MenuListCard(pictures:$meal.item.menus[index].pictures, text:$meal.item.menus[index].notes, forceClose: $forceAllSwipesClosed, onSave: onSave) {
                                        meal.item.menus.remove(at: index)
                                        onSave()
                                    }
                                    .padding(.bottom, -2)
                                    .onDrag {
                                        self.draggingIndex = index
                                        return NSItemProvider(object: NSString())
                                    }
                                    .onDrop(of: [UTType.text], delegate: DragDelegate(dropIndex: index, listData: $meal.item.menus, dragIndex: $draggingIndex, onSave:onSave))
                                }
                                .onMove(perform: {_, _  in })
                                .transition(.asymmetric(insertion: .opacity,
                                                        removal: .slide))

                                .id(meal.item.menus.count)
                            }
                            
                            BarButtonTriggeringMultiImageTextInput(title: "What's the name of this menu?", addTitle: "Add Menu", pictures:$newMenu.pictures, text:$newMenu.notes) {
                                meal.item.menus.append(newMenu)
                                onSave()
                                newMenu = PicturesAndNotes()
                            }
                        }
                        
                        VerticalSpace(16)
                        
                        // Courses
                        ViewSection("Courses") {
                            VStack {
                                SwipeViewGroup {
                                    ForEach(Array(zip(meal.item.courses.indices, meal.item.courses)), id: \.0) { index, course in
                                        
                                        CourseListCard(course:course, forceClose: $forceAllSwipesClosed) {
                                            viewModel.removeCourse(course)
                                            meal.item = viewModel.getMealFor(meal.item.id)!
                                        }
                                            .padding(.bottom, -2)
                                            .onDrag {
                                                self.draggingIndex = index
                                                return NSItemProvider(object: NSString())
                                            }
                                            .onDrop(of: [UTType.text], delegate: DragDelegate(dropIndex: index, listData: $meal.item.courses, dragIndex: $draggingIndex, onSave:onSave))
                                    }
                                    .onMove(perform: {_, _  in })
                                    .id(meal.item.courses.count)
                                }

                                BarButtonTriggeringTextInput(title: "What's the name of the course?", addTitle: "Add Course", text:$courseName, itemNum:meal.item.courses.count) {
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
                        
                        VerticalSpace(200)
                        
                    }
                    .padding(.horizontal, 24)
                }
            }
            .onAppear() {
                reload()
            }
            
            TopFade()
            
            BottomFade()
            
            // Buttons
            BottomButtonContainer() {
                LargeActionRedButton(icon:"\u{e917}", font:"foodie-icons-v1-1") {
                    self.presentationMode.wrappedValue.dismiss()
                }
                
                Spacer()
                
                LargeActionWhiteShareButton(
                    subject: "Notes about my meal at \(meal.item.venue.name) on \(meal.item.date.formatted(date: .complete, time: .omitted))",
                    message: ModelIOService.exportAsString(meal.item),
                    preview: "Notes about my meal at \(meal.item.venue.name) on \(meal.item.date.formatted(date: .complete, time: .omitted))")
            }
        }
        .onDisappear() {
            forceAllSwipesClosed.toggle()
        }
        .ignoresSafeArea(.all)
        .navigationBarHidden(true)
        .preferredColorScheme(.dark)
    }
    
    private func reload() {
        if let savedMeal = viewModel.getMealFor(meal.item.id) {
            meal.item = savedMeal
        }
    }
    
    private func onSave() {
        viewModel.saveEditedMealFor(meal.item)
    }
}
