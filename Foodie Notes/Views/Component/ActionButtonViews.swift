//
//  ActionButtonViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/9/24.
//

import SwiftUI



struct AddImageButton: View {
    @Binding var loading:Bool;
    var dim:CGFloat = 80;
    var action:() -> Void = {}
    
    var body: some View {
        Button(
            action: action,
            label: {
                VStack(alignment: .center, spacing: 0) {
                    FoodieIcon("\u{e913}", Colors.FillActionFillAction, size:24, padding:0)
                }
                .padding(0)
                .frame(width: dim, height: dim, alignment: .center)
                .cornerRadius(8)
            }
        )
        .buttonStyle(AddImageButtonButtonStyle())
        .disabled(loading)
        .opacity(loading ? 0 : 1)
    }
}

private struct AddImageButtonButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Colors.FillActionFillActionPressedSubtle : Colors.BackgroundBgPrimary)
            .overlay(
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .inset(by: 0.75)
                        .stroke(Colors.BorderActionBorderActionSubtle, style: StrokeStyle(lineWidth: 1.5, dash: [2, 2]))
                        .opacity(configuration.isPressed ? 0 : 1)
                    RoundedRectangle(cornerRadius: 8)
                        .inset(by: 0.5)
                        .stroke(Colors.BorderStaticBorderSubtle, lineWidth: 1)
                        .opacity(configuration.isPressed ? 1 : 0)
                }
            )
    }
}


struct BarButton: View {
    var icon:String = "\u{e91f}"
    let text: String;
    let action: () -> Void;
    
    var body: some View {
        Button(
            action: {
                action()
            },
            label: {
                HStack {
                    HStack {
                        FoodieIcon(icon, Colors.BorderActionBorderAction, padding:0)
                        Spacer()
                            .frame(width:8)
                        FoodieText(text, Colors.TextActionTextAction, size:14, weight:.semibold)
                    }
                    .frame(maxWidth: .infinity, minHeight: 64, maxHeight: 64, alignment: .center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: 0.75)
                            .stroke(Colors.BorderStaticBorderSecondary, lineWidth: 1.5)
                    )
                }
            }
        )
        .buttonStyle(BarButtonStyle())
    }
}

struct SmallClearButton: View {
    var disabled:() -> Bool = { false };
    let action:() -> Void
    
    var body: some View {
        ActionButton(action:action)
            .buttonStyle(SmallClearButtonStyle(disabled:disabled()))
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

struct BottomButtonContainer<Content: View>: View {
    @ViewBuilder let buttons: Content
    
    var body: some View {
        HStack(alignment: .top) {
            buttons
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
    var dim:CGFloat = 64
    var iconSize:CGFloat = 32;
    
    var body: some View {
        ActionButton(action:action, dim:dim)
            .disabled(disabled)
            .buttonStyle(LargeActionRedButtonStyle(icon:icon, iconSize:iconSize, disabled:disabled))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
    }
}

struct LargeActionWhiteButton: View {
    let icon:String;
    let action:() -> Void
    
    var body: some View {
        ActionButton(action:action, dim: 48)
            .buttonStyle(LargeActionWhiteButtonStyle(icon:icon))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

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

struct CheckboxButton : View {
    @Binding var value:Bool
    let text:String;
    var action: () -> Void = {}
    
    var body: some View {
        Button(
            action: {
                value.toggle()
                action()
            },
            label: {
                HStack(alignment: .center, spacing: 8) {
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 56, maxHeight:56, alignment: .leading)
            }
        )
        .buttonStyle(CheckboxButtonStyle(text:text, selected:value))
    }
}

// MARK: - Styles

private struct BarButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Colors.FillStaticFillSecondary : Colors.BackgroundBgPrimary)
            .cornerRadius(8)
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
    var iconSize:CGFloat = 32
    var disabled:Bool = false;

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(disabled ? Colors.FillActionFillDisabled : configuration.isPressed ? Colors.FillActionFillActionPressed : Colors.FillActionFillAction)
            .cornerRadius(80)
            .overlay() {
                FoodieIcon(icon, disabled ? Colors.FillActionFillActionIconDisabled : configuration.isPressed ? Colors.FillActionFillActionPressedIcon : Color.white, size:iconSize, padding:0)
            }
            .shadow(color: disabled ? Color.clear : Colors.ShadowHighVibrant, radius: 8, x: 0, y: 16)
            .opacity(disabled ? 0 : 1)
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

private struct CheckboxButtonStyle: ButtonStyle {
    let text:String;
    var selected:Bool = false;
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Colors.FillActionFillActionPressedSubtle : Colors.BackgroundBgPrimary)
            .cornerRadius(8)
            .overlay(
                ZStack {
                    HStack(alignment: .center, spacing: 8) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .inset(by: 0.75)
                                .stroke(Colors.BorderActionBorderActionSubtle, lineWidth: !configuration.isPressed && !selected ? 1.5 : 0)
                                .frame(width: 24, height: 24, alignment: .topLeading)
                                .background(selected ? Colors.FillActionFillActionSelected: configuration.isPressed ? Colors.FillActionFillActionPressed : Colors.BackgroundBgPrimary)
                                .cornerRadius(4)
                            
                            FoodieIcon("\u{e905}", .white, size:24, padding:0)
                                .opacity(selected ? 1.0 : 0)
                        }
                        .padding(.leading, 8)
                        
                        
                        FoodieText(text, Colors.TextStaticTextSecondary, size:14, weight:.semibold)
                    }
                    .padding(.horizontal, 8)
                    .cornerRadius(8)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(configuration.isPressed ? Colors.BorderStaticBorderSubtle : Colors.BackgroundBgPrimary, lineWidth: 1)
                }
            )
    }
}
