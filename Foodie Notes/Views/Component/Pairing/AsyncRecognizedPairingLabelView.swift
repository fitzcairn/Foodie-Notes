//
//  AsyncRecognizedWineLabelView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/26/24.
//

import SwiftUI

struct AsyncRecognizedPairingLabelView<Source:AsyncLabelRecognitionConfig, ProgressContent: View, LinkContent: View, ErrorContent: View>: View {
    @ObservedObject var source:Source
    let img: SavedImage;
    @ViewBuilder let progressContent: ProgressContent;
    @ViewBuilder let linkContent: LinkContent;
    @ViewBuilder let errorContent: ErrorContent;

    var body: some View {
        switch source.status {
        case .loading:
            progressContent
                .onAppear {
                    self.source.recognizeWineLabelFor(self.img)
                }
        case .complete:
            linkContent
        case .error, .none:
            errorContent
        }
    }
}
