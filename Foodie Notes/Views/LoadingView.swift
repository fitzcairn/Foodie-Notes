//
//  LoadingView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/1/24.
//

import SwiftUI


struct LoadingView: View {
    @EnvironmentObject var viewModel:AppViewModel;
    
    var body: some View {
        
        ZStack {
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.97, green: 0.35, blue: 0.47), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.92, green: 0.19, blue: 0.41), location: 1.00),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Image(uiImage: UIImage(named: "Group 4")!)
                    .frame(width: 78.84178, height: 80.97295)
                    .padding(.bottom, -30)
                    .padding(.leading, 4)
                Text("Foodie")
                    .font(
                        Font.custom("Nunito", size: 64)
                            .weight(.heavy)
                    )
                    .foregroundColor(.white)
                    .padding(.bottom, -66)
                Text("Notes")
                    .font(
                        Font.custom("Nunito", size: 64)
                            .weight(.heavy)
                    )
                    .foregroundColor(.white)
            }
        }
        .task {
            do {
                try await viewModel.fromLoad(model:ModelIOService.loadAppModel())
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}
