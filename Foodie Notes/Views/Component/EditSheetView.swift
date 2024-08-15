//
//  EditSheetView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/10/24.
//

import SwiftUI


private struct EditSheetCommon<TopLeftButton: View, TopRightButton: View, MainView: View>: View {
    @ViewBuilder let topLeftButton: TopLeftButton;
    @ViewBuilder let topRightButton: TopRightButton;
    @ViewBuilder let mainView: MainView;

    var body: some View {
        HStack(alignment: .top) {
            HStack(alignment: .center, spacing: 4) {
                topLeftButton
            }
            .padding(.horizontal, 16)
            .frame(width: 48, height: 48, alignment: .center)
            .cornerRadius(80)
            
            Spacer()
            
            topRightButton
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, -8) // Hack

        Divider()
            .padding(.bottom, 8)
        
        VStack {
            mainView
        }
        .padding(.horizontal, 25)
    }
}

struct EditSheetView<TopLeftButton: View, TopRightButton: View, MainView: View, BottomButtons: View> : View {
    @ViewBuilder let topLeftButton: TopLeftButton;
    @ViewBuilder let topRightButton: TopRightButton;
    @ViewBuilder let mainView: MainView;
    @ViewBuilder let bottomButtons: BottomButtons;

    var body: some View {
        ZStack {
            ScrollView {
                EditSheetCommon(topLeftButton: {topLeftButton}, topRightButton: {topRightButton}, mainView: {mainView})
                Spacer()
            }
            .scrollIndicators(.hidden)
            
            VStack {
                Spacer()
                
                bottomButtons
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
