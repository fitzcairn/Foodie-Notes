//
//  WineListCard.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/16/24.
//

import SwiftUI

struct WineListCard: View {
    @EnvironmentObject var viewModel:AppViewModel;
    @State var showSheet:Bool = false;
    
    @Binding var name:String
    @Binding var picture:Picture?
    @Binding var notes:String
    @Binding var forceClose:Bool;
    var onSave:() -> Void = {}
    let onDelete:() -> Void;

    var body: some View {
        
        WineBox() {
            // Top: swipeable image and name card.
            
            SwipeableListCard(
                confirmString: "Delete this Pairing?",
                onDelete: onDelete,
                forceClose: $forceClose) {
                    HStack(alignment: .top, spacing: 0) {
                        
                        // Picture Frame
                        HStack(alignment: .center, spacing: 10) {
                            
                            // Actual Picture
                            HStack(alignment: .bottom, spacing: 4) {
                                ExpandableImageGallery(src: .picture(picture)) {
                                    CourseListPicture(picture:picture)
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
                            EditableWineSheetLayout(title:"What's the name of this pairing?", text: $name, picture: $picture, showSheet: $showSheet, onSave:onSave) {
                                FoodieText(name, Colors.TextStaticTextPrimary, size:14, weight:.bold)
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
            
            // Bottom: notes field.
            EditableStandaloneTextBox(title: "What were your notes on this pairing?", addTitle: "Add notes", text: $notes, onSave:onSave)
        }
    }
}
