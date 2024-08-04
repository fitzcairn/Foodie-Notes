//
//  LoadingView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/1/24.
//

import SwiftUI


struct Constants {
    static let Spacing5: CGFloat = 48
    static let BorderHairline: CGFloat = 1
}

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

/*ZStack {
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
}*/
