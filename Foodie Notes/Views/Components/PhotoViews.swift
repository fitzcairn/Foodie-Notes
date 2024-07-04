//
//  PhotoViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/4/24.
//

import SwiftUI
import PhotosUI


struct PhotoViews : View {
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    
    var body : some View {
        VStack {
            PhotosPicker("Select a picture", selection: $pickerItem, matching: .images)
        }
    }
}

struct SelectFromRollButton : View {
    @Binding var selectedImage: Image?
    @Binding private var pickerItem: PhotosPickerItem?

    var body : some View {
        VStack {
            PhotosPicker(selection: $pickerItem, matching: .images) {
                Image(systemName: "gear")//rectangle.2.swap")
                    .resizable()
                    .padding(4)
                    .frame(width: 20, height: 20)
                    .background(Color.red)
                    .clipShape(Circle())
                    .foregroundColor(.white)
            }
        }
    }
}
