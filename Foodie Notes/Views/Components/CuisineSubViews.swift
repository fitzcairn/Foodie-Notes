//
//  CuisineSubViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/17/24.
//

import SwiftUI

struct CuisineSubViews {
    
    struct CuisineViewSection : View {
        let cuisines:[Cuisine];

        var body: some View {
            Section(header: Text(SectionTitle.cuisine)) {
                HStack {
                    ForEach(Array(zip(cuisines.indices, cuisines)), id: \.0) { index, cuisine in
                        HStack {
                            Text(cuisine.displayName)
                                .font(.system(size:14, weight: .regular))
                                .foregroundColor(.white)
                                .padding(4)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(1)
                                .frame(minHeight:24)
                        }
                        .background(Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .buttonStyle(.borderless)
                    }
                }
            }
        }
    }
    
    struct CuisineEditSection : View {
        @Binding var cuisines:[Cuisine];

        @State private var searchString:String = ""
        @State private var showList:Bool = false;
        
        var body: some View {
            Section(header: Text(SectionTitle.cuisine)) {
                HStack {
                    CuisinePillView(cuisines: $cuisines)
                        .opacity(cuisines.count > 0 ? 1 : 0)
                    StyledTextField(inputText: $searchString, prompt:"Search Cuisines") {
                        showList = true;
                    }
                    .onTapGesture {
                        showList = true;
                    }
                    .popover(isPresented: $showList) {
                        SuggestionsView(
                            searchString:$searchString,
                            showList:$showList,
                            cuisines:$cuisines
                        )
                    }
                }
            }
        }
    }
    
    private struct CuisinePillView : View {
        @Binding var cuisines:[Cuisine];
        
        var body: some View {
            HStack {
                ForEach(Array(zip(cuisines.indices, cuisines)), id: \.0) { index, cuisine in
                    HStack {
                        Text(cuisine.displayName)
                            .font(.system(size:14, weight: .regular))
                            .foregroundColor(.white)
                            .padding(.leading, 2)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(1)
                        Button(
                            action: {
                                cuisines.remove(at:index)
                            },
                            label: {
                                Image(systemName: "x.circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(Color.white)
                                    .padding(.trailing, 2)
                                    .padding(.top, 2)
                                    .padding(.bottom, 2)
                            }
                        )
                    }
                    .background(Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .buttonStyle(.borderless)
                }
            }
        }
    }
    
    private struct SuggestionsView : View {
        private static let allCuisines = Cuisine.allCases
        
        @Binding var searchString:String;
        @Binding var showList:Bool;
        @Binding var cuisines:[Cuisine];

        var body: some View {
            VStack() {
                List(CuisineSubViews.SuggestionsView.allCuisines.filter({searchString == "" ? true : $0.displayName.contains(searchString)}), id: \.self) { cuisine in
                    HStack {
                        Text(cuisine.displayName)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        cuisines.append(cuisine)
                        searchString = ""
                        showList = false;
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .frame(width: 400, height: 400)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .presentationCompactAdaptation(.popover)
        }
    }
}
