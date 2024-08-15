//
//  View_BorderAnimation.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/15/24.
//

import SwiftUI

extension View {
    func borderLoadingAnimation(isAnimating: Binding<Bool>) -> some View {
        modifier(BorderLoadingAnimation(isAnimating: isAnimating))
    }
}

struct BorderLoadingAnimation: ViewModifier, Animatable {
    @Binding var isAnimating: Bool

    private let lineWidth: CGFloat = 3
    private let cornerRadius: CGFloat = 8
    
    var animatableData: Bool {
        get { isAnimating }
        set { isAnimating = newValue }
    }

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .foregroundStyle(.clear)
                        
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .frame(width:geometry.size.width * 0.7, height: geometry.size.height*2)
                            .foregroundStyle(Colors.LoadingBorder)
                            .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        
                            .mask {
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .stroke(lineWidth: lineWidth)
                                    .frame(width: geometry.size.width - lineWidth, height: geometry.size.height - lineWidth)
                            }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            )
            .ignoresSafeArea()
    }
}
