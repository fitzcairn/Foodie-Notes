//
//  IconsAndnText.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/30/24.
//

import SwiftUI


struct FoodieIcon: View {
    let font:String;
    let icon:String;
    let color:Color;
    let size:CGFloat;
    let edge:Edge.Set
    let padding:CGFloat;
    
    init(_ icon: String, _ color:Color, size: CGFloat = 24, edge: Edge.Set = .horizontal, padding: CGFloat = 8, font: String = "foodie-icons") {
        self.icon = icon
        self.color = color
        self.size = size
        self.edge = edge
        self.padding = padding
        self.font = font
    }
    
    var body: some View {
        Text(icon)
            .font(Font.custom(font, size: size))
            .foregroundColor(color)
            .padding(edge, padding)
    }
}

struct FoodieText: View {
    let text:String;
    let color:Color;
    let size:CGFloat;
    let weight:Font.Weight;
    
    init(_ text: String, _ color: Color, size: CGFloat = 16, weight: Font.Weight = .bold) {
        self.text = text
        self.color = color
        self.size = size
        self.weight = weight
    }
    
    var body: some View {
        Text(text)
          .font(
            Font.custom("Nunito", size: size)
              .weight(weight)
          )
          .foregroundColor(color)
    }
}


struct MyDivider: View {
    var body: some View {
        Divider()
            .frame(height: 1.5)
            .background(Colors.BorderStaticBorderSubtle)
    }
}
