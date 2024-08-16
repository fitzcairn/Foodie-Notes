//
//  SwipeableListCard.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/15/24.
//

import SwiftUI
import SwipeActions
import Combine

struct SwipeableListCard<Content: View>: View {
    @EnvironmentObject var viewModel:AppViewModel;
    @State var deleted:Bool = false;
    @State var showConfirm:Bool = false;
    @State var swipeState:SwipeContext?;
    
    let confirmString:String;
    let onDelete:() -> Void;
    @Binding var forceClose:Bool;
    @ViewBuilder let content:Content;

    
    var body: some View {
        if deleted {
            EmptyView()
        } else {
            ZStack(alignment: .leading) {
                SwipeView {
                     content
                } trailingActions: { context in
                    SwipeAction(
                        action: {
                            showConfirm.toggle()
                            swipeState = context;
                        },
                        label: { highlight in
                            FoodieIcon("\u{e928}", .white)
                                .onAppear() {
                                    swipeState = context;
                                }
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
            .alert(confirmString,
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
                    Task {
                        onDelete()
                    }
                }
            })
            .onChange(of: forceClose) {
                if let context = swipeState {
                    context.state.wrappedValue = .closed
                }
            }
        }
    }
}
