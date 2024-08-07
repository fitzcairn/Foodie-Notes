//
//  MealListSortMenu.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/7/24.
//

import SwiftUI


struct MealListSortMenu: View {
    private var menuWidth:CGFloat = 160;
    
    @State private var menuHeight:CGFloat = 0.0
    @State private var showMenu:Bool = false;
    @State private var isFullScreenViewVisible = false

    @Binding var sortOrder:AppViewModel.MealSortOrder;

    init(sortOrder: Binding<AppViewModel.MealSortOrder>) {
        self._sortOrder = sortOrder
    }
    
    private func saveOption(_ option:AppViewModel.MealSortOrder) {
        sortOrder = option;
        showMenu.toggle()
        isFullScreenViewVisible.toggle();
    }
    
    private var optionsMenu: some View {
        VStack(alignment: .leading, spacing: 0) {
            MealListSortMenuButton("Date, descending") {
                saveOption(.dateDesc)
            }
            MealListSortMenuButton("Date, ascending") {
                saveOption(.dateAsc)
            }
            MealListSortMenuButton("Name of venue") {
                saveOption(.name)
            }
            MealListSortMenuButton("Location") {
                saveOption(.location)
            }
            MealListSortMenuButton("Your rating") {
                saveOption(.rating)
            }
            MealListSortMenuButton("Michelin rating") {
                saveOption(.michelin)
            }
        }
        .buttonStyle(.plain)
        .frame(width: menuWidth)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Colors.ShadowModal, radius: 12, x: 0, y: 16)
    }
       
    var body: some View {
        FoodieIcon("\u{e923}", Colors.TextActionTextAction)
            .onTapGesture {
                withAnimation(.easeIn(duration:0.2)) {
                    showMenu.toggle()
                }
            }
            .fullScreenCover(isPresented: $showMenu, content: {
                Group {
                    if isFullScreenViewVisible {
                        GeometryReader { geo in
                            ZStack {
                                Rectangle()
                                    .scaledToFill()
                                    .ignoresSafeArea()
                                    .foregroundColor(.black)
                                    .opacity(0.2)
                                    .background(BackgroundClearView())
                                
                                // Positioning is a total hack, but the most reliable way I
                                // found to do it. :(
                                optionsMenu
                                    .background {
                                        GeometryReader { geometry in
                                            Color.clear
                                                .onAppear {
                                                    menuHeight = geometry.frame(in: .global).height
                                                }
                                        }
                                    }
                                    .position(
                                        x: geo.frame(in: .global).width - menuWidth/2 - 20,
                                        y: geo.frame(in: .global).origin.y + menuHeight/2 + 20
                                    )
                                
                            }
                        }
                    }
                }
                .onAppear {
                    isFullScreenViewVisible = true
                }
                .onTapGesture {
                    isFullScreenViewVisible = false;
                    showMenu = false;
                }
            })
            .transaction({ transaction in
                transaction.disablesAnimations = true
            })
            .animation(.linear(duration: 0.2), value: isFullScreenViewVisible)
    }
}

private struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

private struct MealListSortMenuButton: View {
    @State private var tap:Bool = false;

    let label: String
    let action: () -> Void
    
    init(_ label: String, action: @escaping () -> Void) {
        self.label = label
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.linear(duration: 0.01)) {
                self.tap.toggle();
            }
            action()
        }, label: {
            HStack(spacing: 0) {
                FoodieText(label, tap ? .white : Colors.FillActionFillActionSelected, size:14, weight:.semibold)
                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal)
            .contentShape(Rectangle())
            .background(tap ? Colors.FillActionFillActionSelected : .white)
        })
        .buttonStyle(.plain)
    }
}
