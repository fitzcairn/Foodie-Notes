//
//  SearchableMap.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/23/24.
//  Taken almost directly from: https://www.polpiella.dev/mapkit-and-swiftui-searchable-map
//

import SwiftUI
import MapKit

struct SearchableMap: View {
    @Binding var newLocation: SearchResult?;
    
    @State private var selectedLocation: SearchResult?
    @State private var position = MapCameraPosition.userLocation(fallback: .automatic)
    @State private var searchResults = [SearchResult]()
    @State private var isSheetPresented: Bool = true

    var body: some View {
        Map(position: $position,
            bounds: .init(minimumDistance: 100, maximumDistance: 100000),
            selection: $selectedLocation) {
            ForEach(searchResults) { result in
                Marker(coordinate: result.location) {
                    Image(systemName: "mappin")
                }
                .tag(result)
            }
        }
        .ignoresSafeArea()
        .onChange(of: selectedLocation) {
            if selectedLocation == nil {
                isSheetPresented = true
            } else {
                newLocation = selectedLocation
                position = .rect(
                    MKMapRect(
                        origin: .init(newLocation!.location),
                        size: .init(width: 1, height: 1)))
                isSheetPresented = false
            }
        }
        .onChange(of: searchResults) {
            if let firstResult = searchResults.first, searchResults.count == 1 {
                selectedLocation = firstResult
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            SheetView(searchResults: $searchResults)
        }
    }
    
    private struct SheetView: View {
        @State private var mapViewModel = MapViewModel(completer: .init())
        @State private var search: String = ""
        @Binding var searchResults: [SearchResult]

        var body: some View {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search for a restaurant", text: $search)
                        .autocorrectionDisabled()
                        .onSubmit {
                            Task {
                                searchResults = (try? await mapViewModel.search(with: search)) ?? []
                            }
                        }
                }
                .modifier(TextFieldGrayBackgroundColor())

                Spacer()

                List {
                    ForEach(mapViewModel.completions) { completion in
                        Button(action: { didTapOnCompletion(completion) }) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(completion.title)
                                    .font(.headline)
                                    .fontDesign(.rounded)
                                Text(completion.subTitle)
                                if let url = completion.url {
                                    Link(url.absoluteString, destination: url)
                                        .lineLimit(1)
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .onChange(of: search) {
                mapViewModel.update(queryFragment: search)
            }
            .padding()
            .interactiveDismissDisabled()
            .presentationDetents([.height(200), .large])
            .presentationBackground(.regularMaterial)
            .presentationBackgroundInteraction(.enabled(upThrough: .large))
        }

        private func didTapOnCompletion(_ completion: SearchCompletions) {
            Task {
                if let singleLocation = try? await mapViewModel.search(with: "\(completion.title) \(completion.subTitle)").first {
                    searchResults = [singleLocation]
                }
            }
        }
    }

    private struct TextFieldGrayBackgroundColor: ViewModifier {
        func body(content: Content) -> some View {
            content
                .padding(12)
                .background(.gray.opacity(0.1))
                .cornerRadius(8)
                .foregroundColor(.primary)
        }
    }
}
