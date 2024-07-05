//
//  SplashView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/5/24.
//

import SwiftUI

// Intro screen
struct SplashView: View {
    @EnvironmentObject var viewModel:AppViewModel;
    
    var body: some View {
        NavigationStack {
            NavigationLink(destination: MealListView()) {
                ZStack {
                    background
                    
                    VStack() {
                        Text("Happy Birthday, Ying!")
                            .font(Font.custom("ChalkboardSE-Bold", size: 30))
                            .padding(.top, 40)
                            .foregroundColor(.black)

                        Image("icon")
                            .resizable()
                            .frame(width:300, height:300)
                            .padding(.vertical, 10)
                        
                        Text("Love always,\nSteve")
                            .multilineTextAlignment(.center)
                            .font(Font.custom("ChalkboardSE-Bold", size: 20))
                            .padding(.bottom, 60)
                            .foregroundColor(.black)

                        Text("Tap anywhere to continue...")
                            .font(.system(size:14))
                            .foregroundColor(.black)
                            .italic()
                            .padding(.bottom, 20)
                    }
                }
            }
            .simultaneousGesture(TapGesture().onEnded {
                viewModel.model.skipSplash = true;
            })
        }
        .navigationBarBackButtonHidden()
    }
    
    let backgroundColor = Color(red:1, green:0.988, blue:0.914)
    
    var background: some View {
        LinearGradient(gradient: Gradient(colors: [backgroundColor, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}


#Preview {
    SplashView()
}
