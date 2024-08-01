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
                gradient: Gradient(colors: [Color(red:1, green:0.988, blue:0.914), Color.white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            GeometryReader { gp in
                ZStack {
                    Image("icon")
                        .resizable()
                        .frame(width:300, height:300)
                        .padding(.vertical, 10)
                        .alignmentGuide(VerticalAlignment.center, computeValue: { $0[.bottom] })
                        .position(x: gp.size.width / 2, y: gp.size.height / 2)
                    ProgressView()
                        .alignmentGuide(VerticalAlignment.center, computeValue: { $0[.top] - 16 })
                }
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
