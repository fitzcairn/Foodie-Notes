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
        NavigationStack {
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
                                        .onChange(of: course.item.pickedImage) {
                                            print(viewModel.getCourseImageFor(course.item))
                                        }
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
                                //.frame(maxWidth: .infinity)
                                
                            } // Course Metadata
                            
                            VerticalSpace(24)
                            
                            // TODO: Photos
                            
                            // Tasting Notes
                            ViewSection("Tasting Notes") {
                                EditableStandaloneTextBox(title: "Any notes on the food for this course?", addTitle: "Add Notes", text: $course.item.food.notes, onSave:onSave)
                            }
                            
                            // TODO: Pairings
                            
                            
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
            .navigationBarHidden(true)
            .ignoresSafeArea(.all)
        }
    }
    
    private func onSave() {
        viewModel.saveEditedCourse(course.item)
    }
}

/*
 OLD: kept for future reference
 
 var course:Course
 
 var body: some View {
     let course = viewModel.getCourseFor(course.id)!
     NavigationStack {
         ZStack(alignment: .bottom) {
             ScrollForm {
                 CourseSubViews.CourseNameAndPickedImageView(course:course)
                 DateSubViews.DateSection(course.date)
                 if viewModel.checkShow(course.food) {
                     PictureSubViews.PictureAndNotesViewSection(title: SectionTitle.food, data: course.food)
                 }
                 if viewModel.checkShow(course.beveragePairing) {
                     PictureSubViews.PictureAndNotesViewSection(title: SectionTitle.beverage, data: course.beveragePairing, isBeverage: true)
                 }
             }
             PrimaryButtonSubViews.CourseViewPrimaryButtons(
                 backClosure: {
                     self.presentationMode.wrappedValue.dismiss()
                 },
                 editCourseDest: CourseEditView(
                     course:Binding<Course>(
                         get: { viewModel.getCourseFor(course.id)! },
                         set: { viewModel.saveEditedCourse($0) }
                     )
                 )
             )
         }
         .navigationBarBackButtonHidden()
         .navigationBarItems(
             leading: StyledTitleText(ViewTitle.viewCourse)
         )
     }
 }
}
 */
