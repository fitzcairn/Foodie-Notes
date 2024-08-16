//
//  LocationEditSheet.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/16/24.
//

import SwiftUI
import MapKit

struct LocationEditSheet: View {
    @State private var mapViewModel = MapViewModel()
    @State private var searchResults:[SearchResult] = []
    @State private var search: String = ""
    @State private var isFocused:Bool = true;

    @Binding var newLocation: SearchResult?;
    @Binding var name:String
    
    var body: some View {
        VStack {
            SearchBox(
                searchText: $search,
                isFocused: $isFocused,
                assumeFocus: true,
                onChangeClosure: {
                    if search.isEmpty {
                        searchResults = []
                    }
                },
                onSubmitClosure: {
                    Task {
                        searchResults = (try? await mapViewModel.search(with: search)) ?? []
                    }
                }
            )
                        
            Spacer()

            ForEach(searchResults) { result in
                SearchResultCard(result: result, selected: newLocation == result) {
                    print("tap!")
                    newLocation = result
                }
            }
        }
        .onChange(of: searchResults) {
            print(searchResults)
        }
        .onAppear() {
            search = name;
        }
    }
}

private struct SearchResultButtonStyle: ButtonStyle {
    var selected:Bool = false;
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(selected ? .white : configuration.isPressed ? Colors.FillActionFillActionPressedSubtle : Colors.BackgroundBgPrimary)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.75)
                    .stroke(selected ? Colors.BorderActionBorderAction : Colors.BorderStaticBorderSubtle, lineWidth: 1.5)
            )
            .shadow(color: selected ? Colors.ShadowMed : .clear, radius: 8, x: 0, y: 8)
            .shadow(color: selected ? Colors.ShadowEdge : .clear, radius: 4, x: 0, y: 0)
    }
}

private struct SearchResultCard: View {
    let result:SearchResult
    var selected:Bool = false;
    var action:() -> Void;
 
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                FoodieText(result.name, Colors.TextStaticTextPrimary, size:14, weight:.bold)
                FoodieText(result.address, Colors.TextStaticTextSecondary, size:14, weight:.medium)
            }
            .padding(12)
            .cornerRadius(8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(SearchResultButtonStyle(selected:selected))
    }
}
