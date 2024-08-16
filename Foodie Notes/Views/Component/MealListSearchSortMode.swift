//
//  MealListSearchSortMode.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/6/24.
//

import SwiftUI

struct MealListSearchSortMode: View {
    var prompt:String = "Search"
    @Binding var filterText:String;
    @Binding var sortOrder:AppViewModel.MealSortOrder;
    @Binding var isSearching:Bool;

    var body: some View {
        VStack {
            Spacer()
                .frame(height:24)
            
            HStack {
                SearchBox(searchText: $filterText, isFocused:$isSearching)
                
                Spacer()
                    .frame(width:26)
                
                MealListSortMenu(sortOrder:$sortOrder)
            }
            
            Spacer()
                .frame(height:16)
        }
        .padding(.horizontal, 24)
    }
}
