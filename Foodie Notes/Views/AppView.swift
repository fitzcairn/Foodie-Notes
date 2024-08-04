//
//  AppView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/1/24.
//

import SwiftUI

struct AppView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var viewModel:AppViewModel;

    var body: some View {
        switch viewModel.state {
            case .loading:
                LoadingView()
            case .splash, .list:
                LoadingView()
        }
    }
            
}
