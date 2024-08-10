//
//  ActionButtonViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/9/24.
//

import SwiftUI


struct BarButton: View {
    let text:String;
    let actionClosure: () -> Void;
    
    var body: some View {
        BarButtonContent(text)
    }
}

struct BarButtonNav<Destination>: View where Destination: View {
    let text:String;
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            BarButtonContent(text)
        }
        .buttonStyle(BarButtonStyle())
    }
}

private struct BarButtonContent: View {
    let text:String;
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        HStack {
            HStack {
                FoodieIcon("\u{e91f}", Colors.BorderActionBorderAction, padding:0)
                Spacer()
                    .frame(width:8)
                FoodieText("Add a course", Colors.TextActionTextAction, size:14, weight:.semibold)
            }
            .frame(maxWidth: .infinity, minHeight: 64, maxHeight: 64, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.75)
                    .stroke(Colors.BorderStaticBorderSecondary, lineWidth: 1.5)
            )
            .buttonStyle(BarButtonStyle())
        }
    }
}

private struct BarButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Colors.FillStaticFillSecondary : Colors.BackgroundBgPrimary)
            .cornerRadius(8)
    }
}

struct SmallClearButton: View {
    var disabled:Bool = false;
    let action:() -> Void
    
    var body: some View {
        ActionButton(action:action)
            .buttonStyle(SmallClearButtonStyle(disabled:disabled))
    }
}

struct SmallActionBackButton: View {
    let icon:String;
    let action:() -> Void
    
    var body: some View {
        ActionButton(action:action)
        .buttonStyle(SmallActionBackButtonStyle(icon:icon))
    }
}


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
    var disabled:Bool = false;
    let action:() -> Void
    
    var body: some View {
        ActionButton(action:action)
            .disabled(disabled)
            .buttonStyle(LargeActionRedButtonStyle(icon:icon, disabled:disabled))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
    }
}

struct LargeActionWhiteButton: View {
    let icon:String;
    let action:() -> Void
    
    var body: some View {
        ActionButton(action:action)
            .buttonStyle(LargeActionWhiteButtonStyle(icon:icon))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

    }
}

struct MedActionWhiteButton: View {
    let icon:String;
    let action:() -> Void
    
    var body: some View {
        ActionButton(action:action, dim: 48)
            .buttonStyle(MedActionWhiteButtonStyle(icon:icon))
    }
}

private struct MedActionWhiteButtonStyle: ButtonStyle {
    let icon:String;
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(Colors.BackgroundBgTertiary)
            .cornerRadius(80)
            .overlay() {
                FoodieIcon(icon, configuration.isPressed ? .black : Colors.FillActionFillAction, size:24, padding:0)
            }
            .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
            .shadow(color: Colors.ShadowEdge, radius: 4, x: 0, y: 0)
    }
}

struct LargeActionWhiteShareButton: View {
    let subject:String;
    let message:String;
    let preview:String;
    
    var body: some View {
        ShareLink(
            item: "",
            subject: Text(subject),
            message: Text(message),
            preview: SharePreview(preview,
                image: Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
            )
        ) {
            ActionButton.label()
        }
        .buttonStyle(LargeActionWhiteButtonStyle(icon:"\u{e922}"))
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

private struct ActionButton: View {
    let action:() -> Void
    var dim:CGFloat = 64

    var body: some View {
        Button(
            action: {
                action()
            },
            label: {
                ActionButton.label(dim)
            }
        )
    }
    
    static func label(_ dim:CGFloat = 64) -> some View {
        HStack {
        }
        .frame(width: dim, height: dim, alignment: .center)
    }
}


private struct SmallClearButtonStyle: ButtonStyle {
    var disabled:Bool = false;

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(Colors.BackgroundBgPrimary)
            .overlay() {
                FoodieText("Clear", disabled ? Colors.TextActionTextDisabled : configuration.isPressed ? Color.black : Colors.TextActionTextAction, size:14, weight:.semibold)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(width: 48, height: 48, alignment: .center)
            .cornerRadius(80)
    }
}

private struct SmallActionBackButtonStyle: ButtonStyle {
    let icon:String;

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(Colors.BackgroundBgPrimary)
            .cornerRadius(80)
            .overlay() {
                FoodieIcon(icon, configuration.isPressed ? Colors.FillActionFillActionPressedIcon : Colors.FillActionFillAction, size:32, padding:0)
            }
    }
}

private struct LargeActionRedButtonStyle: ButtonStyle {
    let icon:String;
    var disabled:Bool = false;

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(disabled ? Colors.FillActionFillDisabled : configuration.isPressed ? Colors.FillActionFillActionPressed : Colors.FillActionFillAction)
            .cornerRadius(80)
            .overlay() {
                FoodieIcon(icon, disabled ? Colors.FillActionFillActionIconDisabled : configuration.isPressed ? Colors.FillActionFillActionPressedIcon : Color.white, size:32, padding:0)
            }
            .shadow(color: disabled ? Color.clear : Colors.ShadowHighVibrant, radius: 8, x: 0, y: 16)
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
            .shadow(color: Colors.ShadowHigh, radius: 8, x: 0, y: 16)
            .shadow(color: Colors.ShadowEdge, radius: 2, x: 0, y: 1)

    }
}
