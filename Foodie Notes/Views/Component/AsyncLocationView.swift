//
//  AsyncLocationView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/22/24.
//

import SwiftUI

struct AsyncLocationView<Source:AsyncLocationConfig, ProgressContent: View, LocationContent:View>: View {
    @ObservedObject var source:Source
    let progressContent: ProgressContent;
    let locContent: LocationContent;
    
    init(source: Source, @ViewBuilder progressContent: () -> ProgressContent, @ViewBuilder locContent: () -> LocationContent) {
        self.source = source
        self.progressContent = progressContent()
        self.locContent = locContent()
    }
    
    var body: some View {
        switch source.locStatus {
        case .loading:
            progressContent
                .onAppear {
                    source.fetchLocation()
                }
        case .complete:
            locContent
        case .error, .none:
            EmptyView()
        }
    }
}
