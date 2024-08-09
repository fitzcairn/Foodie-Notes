//
//  LargeActionButtons.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/9/24.
//

import SwiftUI


struct BottomButtonContainer<Left: View, Right: View>: View {
    let left: Left
    let right: Right

    init( @ViewBuilder _ left: () -> Left,  @ViewBuilder _ right: () -> Right) {
        self.left = left()
        self.right = right()
    }
    
    var body: some View {
        HStack(alignment: .top) {
            left
            Spacer()
            right
        }
        .padding(.horizontal, 32)
        .padding(.top, 24)
        .padding(.bottom, 32)
    }
}

struct LargeActionRedButton: View {
    let icon:String;
    let action:() -> Void
    
    var body: some View {
        ActionButton(action:action)
        .buttonStyle(LargeActionRedButtonStyle(icon:icon))
        .shadow(color: Colors.ShadowHighVibrant, radius: 8, x: 0, y: 16)
    }
}

struct LargeActionWhiteButton: View {
    let icon:String;
    let action:() -> Void
    
    var body: some View {
        LargeActionWhiteButton.styleShadow(ActionButton(action:action))
    }
    
    static func styleShadow(_ button:some View) -> some View {
        button
            .buttonStyle(LargeActionWhiteButtonStyle(icon:"\u{e922}"))
            .shadow(color: Colors.ShadowHigh, radius: 8, x: 0, y: 16)
            .shadow(color: Colors.ShadowEdge, radius: 2, x: 0, y: 1)
    }
}

struct LargeActionWhiteShareButton: View {
    let subject:String;
    let message:String;
    let preview:String;
    
    var body: some View {
        LargeActionWhiteButton.styleShadow(ShareLink(
            item: "",
            subject: Text(subject),
            message: Text(message),
            preview: SharePreview(preview,
                image: Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
            )
        ) {
            ActionButton.label()
        })
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

private struct ActionButton: View {
    let action:() -> Void

    var body: some View {
        Button(
            action: {
                action()
            },
            label: {
                ActionButton.label()
            }
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    static func label() -> some View {
        HStack {
        }
        .frame(width: 64, height: 64, alignment: .center)
    }
}

private struct LargeActionRedButtonStyle: ButtonStyle {
    let icon:String;

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Colors.FillActionFillActionPressed : Colors.FillActionFillAction)
            .cornerRadius(80)
            .overlay() {
                FoodieIcon(icon, configuration.isPressed ? Colors.FillActionFillActionPressedIcon : Color.white, size:32, padding:0)
            }
    }
}

private struct LargeActionWhiteButtonStyle: ButtonStyle {
    let icon:String;
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Colors.FillActionFillActionPressed : Colors.FillActionFillActionSubtle)
            .cornerRadius(80)
            .overlay() {
                FoodieIcon(icon, configuration.isPressed ? Colors.FillActionFillActionPressedIcon : Colors.FillActionFillAction, size:32, padding:0)
            }
    }
}
