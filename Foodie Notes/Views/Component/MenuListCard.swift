//
//  MenuListCard.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/15/24.
//

import SwiftUI
import SwipeActions
import Combine


struct MenuListCard: View {
    @EnvironmentObject var viewModel:AppViewModel;
    @State var showSheet:Bool = false;
    
    @Binding var pictures:[Picture]
    @Binding var text:String
    @Binding var forceClose:Bool;
    var onSave:() -> Void = {}
    let onDelete:() -> Void;

    var body: some View {
        SwipeableListCard(
            confirmString: "Delete this Menu?",
            onDelete: onDelete,
            forceClose: $forceClose) {
                HStack(alignment: .top, spacing: 0) {
                    
                    // Picture Frame
                    HStack(alignment: .center, spacing: 10) {
                        
                        // Actual Picture
                        HStack(alignment: .bottom, spacing: 4) {
                            ExpandableImageGallery(src: .list(pictures)) {
                                CourseListPicture(picture:pictures.first, num:pictures.count)
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
                    
                    
                    VStack(alignment: .leading, spacing: 4) {
                        EditableTextAndMultiImageSheetLayout(title:"What's the name of this menu?", text: $text, pictures: $pictures, showSheet: $showSheet, onSave:onSave) {
                            FoodieText(text, Colors.TextStaticTextPrimary, size:14, weight:.bold)
                        }
                        .padding(.leading, 8)
                        .padding(.trailing, 16)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .background(Colors.FillStaticFillPrimary)
                        .onTapGesture {
                            showSheet.toggle()
                        }
                    }
                }
            }
    }
}
