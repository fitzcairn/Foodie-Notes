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
    
    @Binding var pairing:BeveragePairing;
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
                                ExpandableImageGallery(src: .picture(pairing.picture)) {
                                    CourseListPicture(picture:pairing.picture)
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
                            EditableWineSheetLayoutForNameAndImage(title:"What's the name of this pairing?", pairing:$pairing, showSheet: $showSheet, onSave:onSave) {
                                FoodieText(pairing.info.name, Colors.TextStaticTextPrimary, size:14, weight:.bold)
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
            EditableStandaloneWineNotesBox(title: "What were your notes on this pairing?", addTitle: "Add notes", pairing:$pairing, onSave:onSave)
            
            HStack(alignment: .center, spacing: 4) {
                if (pairing.sameAsPrevious) {
                    HStack(alignment: .center, spacing: 4) {
                        FoodieIcon("\u{e90e}", Colors.IconSecondary, size:24, padding:0)
                        FoodieText("Shared with prior course", Colors.TextStaticTextSecondary, size:12, weight:.semibold)
                    }
                    .padding(.leading, -4) // Hack

                }
                
                Spacer()
                
                PairingBeverageInfoLinkView(info: $pairing.info)
            }
            .padding(8)
        }
    }
}
