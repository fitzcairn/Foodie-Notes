//
//  MiscViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 6/30/24.
//

import SwiftUI

// Pop an error.
struct ErrorDialog : View {
    let text:String
    @State var showingAlert:Bool = true;
    
    var body: some View {
        EmptyView()
            .alert("Error", isPresented: $showingAlert) {
                Text(text)
                Button("OK", role: .cancel) {
                    showingAlert = false;
                }
            }
    }
}

// Wrap a form with scroll-friendly space at the bottom.
struct ScrollForm<Content: View>: View {
    @ViewBuilder let content: Content
    
    var body: some View {
        Form {
            content
            Section(header:Text("")){ }
                .padding(.bottom, 20)
        }
    }
}

struct StyledTitleText : View {
    let text:String;
    
    init(_ text:String) {
        self.text = text
    }
    
    var body : some View {
        Text(text)
            .font(.system(size:36, weight: .bold))
    }
}

struct LinkImg: View {
    var body: some View {
        Image(systemName: "link")
            .resizable()
            .scaledToFit()
            .frame(height: 18)
            .foregroundColor(Color.gray)
            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
    }
}

struct EditImg: View {
    var body: some View {
        Image(systemName: "pencil")
            .resizable()
            .scaledToFit()
            .frame(height: 18)
            .foregroundColor(Color.red)
            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
    }
}

struct FindImg: View {
    var body: some View {
        Image(systemName: "magnifyingglass.circle")
            .resizable()
            .scaledToFit()
            .frame(height: 18)
            .foregroundColor(Color.green)
            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
    }
}

struct SaveImg: View {
    var body: some View {
        Image(systemName: "checkmark.circle.fill")
            .resizable()
            .scaledToFit()
            .background(Color.white)
            .clipShape(Circle())
            .foregroundColor(.green)
            .frame(height: 18)
            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
    }
}

struct Searching: View {
    var body: some View {
        HStack {
            ProgressView()
                .scaleEffect(x: 0.6, y: 0.6, anchor: .center)
            Spacer()
        }
    }
}

struct StyledTextField : View {
    @Binding var inputText:String;
    var prompt = "Tap to Add/Edit"
    var onChangeClosure:(() -> Void) = {}

    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                TextField("", text:$inputText, prompt: promptText as? Text, axis:.vertical)
                    .padding(.horizontal, 4)
                    .padding(.top, 3)
                    .padding(.bottom, 1)
                    .onChange(of: inputText) {
                        onChangeClosure()
                    }
                    .font(.system(size:14, weight: .regular))
                Spacer()
                Button(
                    action: {
                        self.inputText = ""
                    },
                    label: {
                        Image(systemName: "x.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color.gray)
                    }
                )
                .padding(.trailing, 2)
                .padding(.top, 2)
                .padding(.bottom, 2)
            }
            .buttonStyle(.plain)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 0.5)
            )
        }
    }
    
    var promptText: some View {
        Text(prompt)
            .font(.system(size:15, weight: .regular))
            .foregroundColor(.gray)
    }
}


struct FoodieIcon: View {
    let icon:String;
    let color:Color;
    let size:CGFloat;
    let edge:Edge.Set
    let padding:CGFloat;
    
    init(_ icon: String, _ color:Color, size: CGFloat = 24, edge: Edge.Set = .horizontal, padding: CGFloat = 8) {
        self.icon = icon
        self.color = color
        self.size = size
        self.edge = edge
        self.padding = padding
    }
    
    var body: some View {
        Text(icon)
            .font(Font.custom("foodie-icons", size: size))
            .foregroundColor(color)
            .padding(edge, padding)
    }
}

struct FoodieText: View {
    let text:String;
    let color:Color;
    let size:CGFloat;
    let weight:Font.Weight;
    
    init(_ text: String, _ color: Color, size: CGFloat = 16, weight: Font.Weight = .bold) {
        self.text = text
        self.color = color
        self.size = size
        self.weight = weight
    }
    
    var body: some View {
        Text(text)
          .font(
            Font.custom("Nunito", size: size)
              .weight(weight)
          )
          .foregroundColor(color)
    }
}

struct Loading: View {
    var height:CGFloat = 18
    
    var body: some View {
        HStack {
            ProgressView()
                //.frame(width:height, height: height)
                .scaleEffect(CGSize(width: height/18, height: height/18))
        }
    }
}

