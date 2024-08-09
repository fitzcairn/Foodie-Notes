//
//  ViewSection.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/9/24.
//

import SwiftUI

struct ViewSection<Content: View>: View {
    let content: Content;
    let title:String;
    
    init(_ title:String, @ViewBuilder content: () -> Content) {
        self.title = title;
        self.content = content()
    }
    
    var body: some View {
        VStack {
            FoodieText(title, Colors.TextStaticTextSecondary, size:12, weight:.semibold)
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
            content
        }
    }
}
