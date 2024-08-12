//
//  AsyncLocationView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/22/24.
//

import SwiftUI

struct AsyncLocationView<Source:AsyncLocationConfig, ProgressContent: View, LocationContent:View, ErrorContent:View>: View {
    @ObservedObject var source:Source
    let progressContent: ProgressContent;
    let locContent: LocationContent;
    let errorContent: ErrorContent;

    init(source: Source, @ViewBuilder progressContent: () -> ProgressContent, @ViewBuilder locContent: () -> LocationContent, @ViewBuilder errorContent: () -> ErrorContent) {
        self.source = source
        self.progressContent = progressContent()
        self.locContent = locContent()
        self.errorContent = errorContent()
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
            errorContent
        }
    }
}
