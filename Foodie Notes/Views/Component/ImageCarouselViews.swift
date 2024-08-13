//
//  ImageCarouselViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/13/24.
//

import SwiftUI

struct ImageCarouselHorizontal: View {
    @Binding var pictures:[Picture]
    var mutable:Bool = false;
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(pictures.filter { $0.photo != nil }, id: \.self) { picture in
                    ZStack(alignment: .topTrailing) {
                        ExpandableImageGallery(src: .picture(picture)) {
                            PhotoView(img: picture.photo!.thumb, contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipped()
                                .cornerRadius(8)
                        }
                        
                        if (mutable) {
                            Button(
                                action: {
                                    if let index = pictures.firstIndex(where: { $0 == picture }) {
                                        pictures.remove(at: index)
                                    }
                                },
                                label: {
                                    Rectangle()
                                        .frame(width:32, height:32)
                                        .clipShape(
                                            .rect(
                                                topLeadingRadius: 0,
                                                bottomLeadingRadius: 8,
                                                bottomTrailingRadius: 0,
                                                topTrailingRadius: 8
                                            )
                                        )
                                }
                            )
                            .buttonStyle(DeleteButtonStyle(icon:"\u{e90a}"))
                        }
                    }
                    .contentShape(Rectangle())
                    .frame(width:80, height:80)
                }
                .id(pictures.count)
            }
        }
        .scrollTargetLayout()
    }
}

private struct DeleteButtonStyle: ButtonStyle {
    let icon:String;

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Colors.FillActionFillActionPressed : Colors.FillActionFillAction)
            .overlay() {
                FoodieIcon(icon, configuration.isPressed ? Colors.FillActionFillActionPressedIcon : Color.white, size:24, padding:0)
            }
    }
}

