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
    @State private var newPairing:BeveragePairing = BeveragePairing()

    init(course:Course) {
        self.course = WrappedStruct(withItem:course)
    }

    var body: some View {
        let _ = Self._printChanges()
        ZStack(alignment: .bottom) {
            Color(Colors.BackgroundBgPrimary)
            
            ScrollView {
                ZStack(alignment: .top) {
                    
                    // Image
                    ZStack(alignment: .top) {
                        withAnimation {
                            CoverPicture(picture: viewModel.getCourseImageFor(course.item))
                                .id(course.item.pickedImage)
                        }
                        
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
                            EditableTextRow(title: "What's the name of this course?", text: $course.item.name, onSave:onSave) {
                                FoodieText(course.item.name, Colors.TextStaticTextPrimary, weight: .semibold)
                                    .padding(.horizontal, 4)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }

                            HStack(alignment: .center, spacing: 4) {
                                EditableRatingView(title: "How would you rate your meal here?", rating: $course.item.rating, onSave:onSave){
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

                        VerticalSpace(24)

                        ViewSection("Photos") {
                            ImageCarouselHorizontal(pictures: $course.item.food.pictures, mutable: true)
                        }

                        VerticalSpace(24)
                        
                        ViewSection("Pairing Notes") {
                            EditableWinePairingView(pairings: $course.item.beveragePairings, onSave:onSave)
                            
                            BarButtonTriggeringAddWinePairing(title: "How was this pairing?", addTitle: "Add a pairing", pairing:$newPairing) {
                                course.item.beveragePairings.append(newPairing)
                                newPairing = BeveragePairing()
                                onSave()
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
            .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 150, trailing: 0))
            
            BottomFade()
            
            BottomButtonContainer()  {
                LargeActionRedButton(icon:"\u{e900}") {
                    self.presentationMode.wrappedValue.dismiss()
                }
                
                Spacer()
            }
        }
        .onAppear() {
            if let savedCourse = viewModel.getCourseFor(course.item.id) {
                course.item = savedCourse
            }
        }
        .ignoresSafeArea(.all)
        .navigationBarHidden(true)
    }
    
    private func onSave() {
        print("saving Course \(course.item.id)")
        viewModel.saveEditedCourse(course.item)
    }
}
