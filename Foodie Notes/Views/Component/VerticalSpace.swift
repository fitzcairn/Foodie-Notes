//
//  VerticalSpace.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/9/24.
//

import SwiftUI

struct VerticalSpace: View {
    let height:CGFloat;
    
    init(_ height: CGFloat) {
        self.height = height
    }
    
    var body: some View {
        Spacer()
            .frame(height:height)
    }
}
