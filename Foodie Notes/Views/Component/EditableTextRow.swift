//
//  EditableTextRow.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/9/24.
//

import SwiftUI

struct EditableTextRow<Content: View>: View {
    let content: Content;
    
    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        
        // TODO: Sheet for editing.
        
        VStack(alignment: .trailing, spacing: 4) {
            content
        }
        .padding(12)
        .background(Colors.FillStaticFillPrimary)
        .cornerRadius(8)
        .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
        .shadow(color: Colors.ShadowEdge, radius: 4, x: 0, y: 0)
    }
}
