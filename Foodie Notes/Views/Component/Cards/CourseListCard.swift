//
//  CourseListCard.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/8/24.
//

import SwiftUI
import SwipeActions
import Combine


struct CourseListCard: View {
    @EnvironmentObject var viewModel:AppViewModel;
    
    var course:Course;
    @Binding var forceClose:Bool;
    let onDelete:() -> Void;
    
    var body: some View {
        SwipeableListCard(
            confirmString: "Delete Course?",
            onDelete: onDelete,
            forceClose: $forceClose) {
                HStack(alignment: .top, spacing: 0) {
                    
                    // Picture Frame
                    HStack(alignment: .center, spacing: 10) {
                        
                        // Actual Picture
                        HStack(alignment: .bottom, spacing: 4) {
                            ExpandableImageGallery(src: .list(course.food.pictures)) {
                                CourseListPicture(picture: viewModel.getCourseImageFor(course), num:course.food.pictures.count)
                                    .id(course.pickedImage)
                            }
                        }
                        .padding(.horizontal, 0)
                        .padding(.top, 0)
                        .padding(.bottom, 0)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        .cornerRadius(4)
                        
                    }
                    .padding(4)
                    .frame(minWidth: 64, maxWidth: 64, maxHeight: .infinity, alignment: .leading)
                    .cornerRadius(8)
                    
                    // Everything else, which when tapped on goes to the course.
                    NavigationLink(destination: CourseView(course:viewModel.getCourseFor(course.id) ?? Course(mealId: course.mealId, name:course.name))) {
                        
                        VStack(alignment: .leading, spacing: 4) {
                            FoodieText(course.name, Colors.TextStaticTextPrimary, size:14, weight:.bold)
                            
                            RatingView(rating:course.rating)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 2)
                        }
                        .padding(.leading, 8)
                        .padding(.trailing, 16)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .background(Colors.FillStaticFillPrimary)
                        
                        // Add the chevron
                        HStack(alignment: .center) {
                            FoodieIcon("\u{e908}", Colors.FillStaticFillTertiary, size:24, padding:0)
                        }
                        .frame(maxHeight: .infinity, alignment: .center)
                        .background(Colors.FillStaticFillPrimary)
                        .padding(.trailing, 6)
                    }
                }
            }
    }
}
