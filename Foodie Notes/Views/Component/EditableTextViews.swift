//
//  EditableTextViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/9/24.
//

import SwiftUI


struct EditableImageAndTextBoxRow: View {
    let title:String
    @Binding var pictures:[Picture]
    @Binding var text:String;
    let onSave:() -> Void;

    @State private var textFieldHeight: CGFloat = .zero
    
    var body : some View {
        HStack(alignment: .top, spacing: 10) {
            HStack(alignment: .center) {
                ExpandableImageGallery(src: .list(pictures)) {
                    VariableHeightListPicture(picture: pictures.first, num:pictures.count)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .padding(4)
                }
                .id(pictures.first)
            }
            .frame(width:64, height: textFieldHeight)
            
            EditableTextComponent(title, inputText: $text, onSave:onSave, pictures: $pictures) {
                HStack(alignment: .top, spacing: 4) {
                    FoodieText(text, Colors.TextStaticTextSecondary, size:14, weight:.semibold)
                }
                .padding(8)
                .frame(maxWidth: .infinity, minHeight:64, alignment: .topLeading)
                .background(heightReader)
                
                .onChange(of: text) {
                    print(textFieldHeight)
                }
            }
        }
        .frame(minHeight:64)
        .background(Colors.FillStaticFillPrimary)
        .cornerRadius(8)
        .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
        .shadow(color: Colors.ShadowEdge, radius: 4, x: 0, y: 0)
    }
    
      private var heightReader: some View {
          GeometryReader { proxy in
              let h = proxy.size.height
              Colors.FillStaticFillPrimary
                  .onChange(of: h, initial: true) { oldVal, newVal in
                      textFieldHeight = newVal
                  }
          }
      }
}



struct EditableStandaloneTextBox: View {
    let title:String
    @Binding var text:String;
    let onSave:() -> Void;
    
    var body : some View {
        EditableTextComponent(title, inputText: $text, onSave: onSave) {
            HStack(alignment: .top, spacing: 0) {
                FoodieText(text, Colors.TextStaticTextSecondary, size:14, weight:.semibold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Colors.FillStaticFillPrimary)
            .cornerRadius(8)
            .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
            .shadow(color: Colors.ShadowEdge, radius: 4, x: 0, y: 0)
        }
    }
}


struct EditableTextRow<Content: View>: View {
    let title:String;
    @Binding var text:String;
    let onSave:() -> Void;
    let content: Content;
    
    init(_ title:String, text:Binding<String>, onSave: @escaping () -> Void, @ViewBuilder _ content: () -> Content) {
        self.title = title;
        self._text = text;
        self.onSave = onSave;
        self.content = content()
    }
    
    var body : some View {
        EditableTextComponent(title, inputText: $text, onSave: onSave) {
            VStack(alignment: .trailing, spacing: 4) {
                content
            }
            .padding(12)
            .background(Colors.FillStaticFillPrimary)
            .cornerRadius(8)
            .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
            .shadow(color: Colors.ShadowEdge, radius: 4, x: 0, y: 0)
        }
    }
}

private struct EditableTextComponent<Content: View>: View {
    let title:String;
    let onSave:() -> Void;
    let content: Content;
    @Binding var inputText:String;
    @Binding var pictures:[Picture]
    private let showPictureControls:Bool;
    
    @State var showSheet:Bool = false;
    @State var editText:String;
    @State var newPictures:[Picture] = []
    
    init(_ title:String, inputText:Binding<String>, onSave: @escaping () -> Void, @ViewBuilder _ content: () -> Content) {
        self.title = title;
        self._inputText = inputText;
        self.onSave = onSave;
        self.content = content()
        self._editText = State.init(initialValue: inputText.wrappedValue)
        self._pictures = Binding<[Picture]> ( get: { [] }, set: { _ = $0 } )
        self.showPictureControls = false;
    }
    
    init(_ title:String, inputText:Binding<String>, onSave: @escaping () -> Void, pictures:Binding<[Picture]>, @ViewBuilder _ content: () -> Content) {
        self.title = title;
        self._inputText = inputText;
        self.onSave = onSave;
        self.content = content()
        self._editText = State.init(initialValue: inputText.wrappedValue)
        self._pictures = pictures;
        self._newPictures = State.init(initialValue: pictures.wrappedValue);
        self.showPictureControls = true;
    }
    
    
    var body: some View {
        content
            .onTapGesture {
                showSheet.toggle()
            }
            .sheet(isPresented: $showSheet) {
                EditSheetView(
                    topLeftButton: {
                        SmallActionBackButton(icon: "\u{e900}") {
                            showSheet.toggle()
                        }
                    },
                    topRightButton: {
                        SmallClearButton(disabled: editText.isEmpty) {
                            editText = ""
                        }
                    },
                    editView: {
                        if (showPictureControls) {
                            textAndImageFieldControl
                        } else {
                            textFieldControl
                        }
                    },
                    saveButton: {
                        saveButton
                    },
                    renderSave: !showPictureControls
                )
                .onAppear() {
                    editText = inputText;
                    newPictures = pictures
                }
            }
    }
    
    private var saveButton: some View {
        LargeActionRedButton(icon:"\u{e905}", disabled:(editText.isEmpty && newPictures.isEmpty)) {
            inputText = editText
            pictures = newPictures
            onSave()
            showSheet.toggle()
        }
    }
    
    private var textFieldPrompt: Text {
        Text("Start writing...")
            .font(
                Font.custom("Nunito", size: 18)
                    .weight(.semibold)
            )
            .foregroundColor(Colors.TextStaticTextPrompt)
    }
    
    private var textField: some View {
        TextField("", text:$editText, prompt: textFieldPrompt, axis:.vertical)
            .font(
                Font.custom("Nunito", size: 18)
                    .weight(.semibold)
            )
            .foregroundColor(Colors.TextStaticTextPrimary)
            .padding(8)
    }

    private var textFieldControl: some View {
        VStack(alignment: .leading) {
            FoodieText(title, Colors.TextStaticTextSecondary, size:16, weight:.semibold)
                .padding(8)
            
            VerticalSpace(16)
            
            textField
        }
    }
    
    private var textAndImageFieldControl: some View {
        VStack(alignment: .leading) {
            FoodieText(title, Colors.TextStaticTextSecondary, size:16, weight:.semibold)
                .padding(8)
            
            VerticalSpace(16)
            
            textField
            
            VerticalSpace(16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(newPictures.filter { $0.photo != nil }, id: \.self) { picture in
                        ZStack(alignment: .topTrailing) {
                            ExpandableImageGallery(src: .picture(picture)) {
                                PhotoView(img: picture.photo!.thumb, contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .clipped()
                                    .cornerRadius(8)
                            }
                            
                            Button(
                                action: {
                                    if let index = newPictures.firstIndex(where: { $0 == picture }) {
                                        newPictures.remove(at: index)
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
                        .contentShape(Rectangle())
                        .frame(width:80, height:80)
                    }
                    .id(newPictures.count)
                }
            }
            .scrollTargetLayout()
            
            Spacer()
            
            HStack {
                MultiImagePickerButton(pictures: $newPictures)
                
                Spacer()
                
                saveButton
            }
        }
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
