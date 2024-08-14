//
//  NavigationLazyView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/14/24.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
