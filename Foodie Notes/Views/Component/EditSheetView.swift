//
//  EditSheetView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/10/24.
//

import SwiftUI

struct EditSheetView<TopLeftButton: View, TopRightButton: View, EditView: View, SaveButton: View> : View {
    let topLeftButton: TopLeftButton;
    let topRightButton: TopRightButton;
    let editView: EditView;
    let saveButton: SaveButton;
    let renderSave:Bool;
    
    init(@ViewBuilder topLeftButton: () -> TopLeftButton, @ViewBuilder topRightButton:() -> TopRightButton, @ViewBuilder editView: () -> EditView, @ViewBuilder saveButton: () -> SaveButton, renderSave:Bool = true) {
        self.topLeftButton = topLeftButton()
        self.topRightButton = topRightButton()
        self.editView = editView()
        self.saveButton = saveButton()
        self.renderSave = renderSave;
    }

    var body: some View {
        VStack {
            
            // Top buttons
            HStack(alignment: .top) {
                HStack(alignment: .center, spacing: 4) {
                    topLeftButton
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .frame(width: 48, height: 48, alignment: .center)
                .cornerRadius(80)
                
                Spacer()
                
                topRightButton
            }
            .padding(16)
            
            VStack {
                editView
            }
            .padding(.horizontal, 25)
            
            
            // Allow overriding of the save button.
            if renderSave {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 16) {
                    HStack {
                        Spacer ()
                        saveButton
                    }
                    .padding(.bottom, 0)
                    .padding(.trailing, -8)
                }
                .padding(.horizontal, 32)
                .padding(.top, 24)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 1, green: 0.98, blue: 0.96).opacity(0), location: 0.00),
                            Gradient.Stop(color: Color(red: 1, green: 0.99, blue: 0.96), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 1)
                    )
                )
            }
        }
        .presentationDetents([.fraction(0.95)])
        .presentationContentInteraction(.scrolls)
        .presentationBackground(alignment: .bottom) {
            Color(Colors.BackgroundBgPrimary)
                .cornerRadius(24)
        }
    }
}
