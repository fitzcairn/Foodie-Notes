//
//  CourseView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/30/24.
//

import SwiftUI

struct CourseView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel:AppViewModel;
    
    @ObservedObject private var course:WrappedStruct<Course>;

    init(course:Course) {
        self.course = WrappedStruct(withItem:course)
    }
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(Colors.BackgroundBgPrimary)
            
            ScrollView {
                ZStack(alignment: .top) {
                    
                    // Image
                    ZStack(alignment: .top) {
                        CoverPicture(picture: viewModel.getCourseImageFor(course.item))
                            .id(course.item.pickedImage)
                        
                        // Edit photo button
                        VStack {
                            VerticalSpace(64)
                            
                            HStack {
                                Spacer()
                                
                                SingleImagePickerButton(picture:$course.item.pickedImage, onSave:onSave)
                                    .padding(.trailing, 25)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        VerticalSpace(250)
                        
                        // Course Metadata
                        VStack(alignment: .trailing) {
                            EditableTextRow("What's the name of this course?", text: $course.item.name, onSave:onSave) {
                                FoodieText(course.item.name, Colors.TextStaticTextPrimary, weight: .semibold)
                                    .padding(.horizontal, 4)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }

                            HStack(alignment: .center, spacing: 4) {
                                EditableRatingView("How would you rate your meal here?", rating: $course.item.rating, onSave:onSave){
                                    RatingView(rating:course.item.rating)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 6)
                                }
                            }
                        } // Course Metadata
                        
                        VerticalSpace(24)
                                                
                        // Tasting Notes
                        ViewSection("Tasting Notes") {
                            EditableStandaloneTextBox(title: "Any notes on the food for this course?", addTitle: "Add notes", text: $course.item.food.notes, onSave:onSave)
                        }
                        .onChange(of: course.item.food.notes) {
                            print(course.item.food.notes)
                            print("Cjhanged!")
                        }

                        VerticalSpace(24)

                        ViewSection("Photos") {
                            ImageCarouselHorizontal(pictures: $course.item.food.pictures, mutable: true)
                        }

                        VerticalSpace(24)
                        
                        ViewSection("Pairing Notes") {

                            // TODO: Pairings

                            
                            VStack(alignment: .leading, spacing: 8) {
                                
                                // ForEach picture, show row.
                                
                                HStack(alignment: .center, spacing: 8) {
                                    EditableStandaloneTextBox(title: "What was the name of this pairing?", addTitle: "Add wine name", text: $course.item.beveragePairing.notes, onSave:onSave)
                                    
                                    HStack(alignment: .center, spacing: 0) {
                                        FoodieIcon("\u{e920}", Colors.TextActionTextAction, size:36, padding:0)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 0)
                                    .cornerRadius(8)
                                    .frame(maxHeight:.infinity)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .inset(by: 0.75)
                                            .stroke(Colors.BorderStaticBorderSecondary, lineWidth: 1.5)
                                    )
                                }
                                .padding(0)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                EditableStandaloneTextBox(title: "Any notes on this pairing?", addTitle: "Add notes", text: $course.item.beveragePairing.notes, onSave:onSave)
                                
                                HStack(alignment: .center, spacing: 8) {
                                    VStack(alignment: .leading, spacing: 0) {
                                        
                                    }
                                    .padding(8)
                                    .frame(width: 24, height: 24, alignment: .topLeading)
                                    
                                    .cornerRadius(4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .inset(by: 0.75)
                                            .stroke(Colors.BorderActionBorderActionSubtle, lineWidth: 1.5)
                                    )
                                    
                                    FoodieText("Shared with previous course", Colors.TextStaticTextSecondary, size:14, weight:.semibold)
                                    
                                }
                                .padding(16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .cornerRadius(8)
                            }
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .cornerRadius(16)
                            .overlay(
                              RoundedRectangle(cornerRadius: 16)
                                .inset(by: 0.75)
                                .stroke(Colors.BorderStaticBorderTertiary, lineWidth: 1.5)
                            )
                        }
                        
                        
                        
                    }
                    .padding(.horizontal, 24)
                    
                    
                }
            }
            .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 150, trailing: 0))
            
            BottomFade()
            
            // Buttons
            BottomButtonContainer(
                { LargeActionRedButton(icon:"\u{e900}", action: { self.presentationMode.wrappedValue.dismiss() }) },
                { MultiImagePickerButton(pictures:$course.item.food.pictures) }
            )
            
        }
        .onAppear() {
            course.item = viewModel.getCourseFor(course.item.id) ?? Course(mealId: course.item.mealId)
        }
        .onChange(of: course.item) {
            viewModel.saveEditedCourse(course.item)
        }
        .ignoresSafeArea(.all)
        .navigationBarHidden(true)
    }
    
    private func onSave() {
    }
}
