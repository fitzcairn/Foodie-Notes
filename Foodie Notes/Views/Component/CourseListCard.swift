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
    @State var deleted:Bool = false;
    @State var showConfirm:Bool = false;
    @State var swipeState:SwipeContext?;
    
    let course:Course;
    
    var body: some View {
        if deleted {
            EmptyView()
        } else {
            ZStack(alignment: .leading) {
                
                SwipeView {
                    NavigationLink(destination: CourseView(course:course)) {
                        // Course Card
                        HStack(alignment: .top, spacing: 0) {
                            
                            // Picture Frame
                            HStack(alignment: .center, spacing: 10) {
                                
                                // Actual Picture
                                HStack(alignment: .bottom, spacing: 4) {
                                    CourseListPicture(picture: viewModel.getCourseImageFor(course), num:4)
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
                            
                            
                            VStack(alignment: .leading, spacing: 4) {
                                FoodieText(course.name, Colors.TextStaticTextPrimary, size:14, weight:.bold)
                                
                                RatingView(rating:course.rating)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 6)
                            }
                            .padding(.leading, 8)
                            .padding(.trailing, 16)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        }
                    }
                } trailingActions: { context in
                    SwipeAction(
                        action: {
                            showConfirm.toggle()
                            swipeState = context;
                        },
                        label: { highlight in
                            FoodieIcon("\u{e928}", .white)
                        },
                        background: { highlight in
                            Rectangle()
                                .foregroundColor(Colors.Delete)
                        })
                    .swipeActionLabelFixedSize(true)
                    .allowSwipeToTrigger(false)
                }
                .swipeActionWidth(72)
                .swipeActionsVisibleEndPoint(60)
                .swipeActionsStyle(.mask)
                .swipeActionCornerRadius(0)
                .swipeSpacing(0)
                .swipeActionsMaskCornerRadius(0)
                .swipeMinimumDistance(20)
                .swipeReadyToExpandPadding(20)
            }
            .animation(nil, value: 0)
            .frame(maxWidth: .infinity, minHeight: 64, maxHeight: 64, alignment: .topLeading)
            .background(Colors.FillStaticFillPrimary)
            .cornerRadius(8)
            .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
            .shadow(color: Colors.ShadowEdge, radius: 4, x: 0, y: 0)
            .alert("Delete Course?",
                   isPresented: $showConfirm,
                   actions: {
                Button("No", role: .cancel) {
                    if let context = swipeState {
                        context.state.wrappedValue = .closed
                    }
                    showConfirm.toggle()
                }
                Button ("Yes", role: .destructive) {
                    deleted = true;
                    //viewModel.removeCourse(course.id); <-- TODO: Write
                }
            })
        }
    }
}
