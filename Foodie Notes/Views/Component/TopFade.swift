//
//  TopFade.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/23/24.
//

import SwiftUI

struct TopFade: View {
    var body: some View {
        VStack() {
            LinearGradient(
                stops: [
                    Gradient.Stop(color: .black.opacity(0.25), location: 0.00),
                    Gradient.Stop(color: .black.opacity(0), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
            .frame(height:64)

            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
    }
}
