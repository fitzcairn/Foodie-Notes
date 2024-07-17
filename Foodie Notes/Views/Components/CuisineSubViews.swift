//
//  CuisineSubViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/17/24.
//

import SwiftUI
import iOSDropDown

struct CuisineSubViews {
    
    struct CuisineViewSection : View {
        let cuisine:String;
        
        var body: some View {
            Section(header: Text(SectionTitle.cuisine)) {
                HStack {
                    Text(cuisine)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                }
            }
        }
    }
    
    struct CuisineEditSection : View {
        @Binding var cuisine: String
        
        var body: some View {
            Section(header: Text(SectionTitle.cuisine)) {
                HStack {
                }
            }
        }
    }
}
