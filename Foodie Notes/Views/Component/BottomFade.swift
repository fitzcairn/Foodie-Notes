//
//  BottomFade.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/8/24.
//

import SwiftUI

struct BottomFade: View {
    var body: some View {
        VStack() {
            Spacer()
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 1, green: 0.98, blue: 0.96).opacity(0), location: 0.00),
                    Gradient.Stop(color: Color(red: 1, green: 0.99, blue: 0.96), location: 1.00),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height:120)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
