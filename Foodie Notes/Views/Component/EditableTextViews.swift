//
//  EditableTextViews.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/9/24.
//

import SwiftUI
import WrappingHStack

struct EditableVerticallyExpandingImageAndTextBoxRow: View {
    let title:String
    let addTitle:String
    @Binding var pictures:[Picture]
    @Binding var text:String;
    let onSave:() -> Void

    @State private var textFieldHeight: CGFloat = .zero
    @State var showSheet:Bool = false;
    
    var body : some View {
        if text.isEmpty && pictures.isEmpty {
            EditableTextAndMultiImageSheetLayout(title:title, text: $text, pictures: $pictures, showSheet: $showSheet, onSave:onSave) {
                BarButton(icon: "\u{e91d}", text: addTitle, action: {
                    text = "";
                    showSheet.toggle()
                })
            }
        } else {
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
                
                EditableTextAndMultiImageSheetLayout(title:title, text: $text, pictures: $pictures, showSheet: $showSheet, onSave:onSave) {
                    HStack(alignment: .top, spacing: 4) {
                        FoodieText(text, Colors.TextStaticTextSecondary, size:14, weight:.semibold)
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity, minHeight:64, alignment: .topLeading)
                    .background(heightReader)
                    .onTapGesture {
                        showSheet.toggle()
                    }
                }
            }
            .frame(minHeight:64)
            .background(Colors.FillStaticFillPrimary)
            .cornerRadius(8)
            .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
            .shadow(color: Colors.ShadowEdge, radius: 4, x: 0, y: 0)
        }
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
    let addTitle:String
    @Binding var text:String;
    let onSave:() -> Void

    @State var showSheet:Bool = false;

    var body : some View {
        EditableTextSheetLayout(title: title, text: $text, showSheet: $showSheet, onSave:onSave) {
            if text.isEmpty {
                BarButtonTriggeringTextInput(title: title, addTitle: addTitle, text: $text, icon:"\u{e91d}", onSave:onSave)
            } else {
                HStack(alignment: .top, spacing: 0) {
                    FoodieText(text, Colors.TextStaticTextSecondary, size:14, weight:.semibold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(Colors.FillStaticFillPrimary)
                .cornerRadius(8)
                .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
                .shadow(color: Colors.ShadowEdge, radius: 4, x: 0, y: 0)
                .onTapGesture {
                    showSheet.toggle()
                }
            }
        }
    }
}

struct LargeRedButtonTriggeringTextInput: View {
    let title:String
    @Binding var text:String;
    let onSave:() -> Void

    @State var showSheet:Bool = false;

    var body : some View {
        EditableTextSheetLayout(title: title, text: $text, showSheet: $showSheet, onSave:onSave) {
            LargeActionRedButton(icon: "\u{e91f}", action: {
                text = "";
                showSheet.toggle()
            })
        }
    }
}

struct BarButtonTriggeringTextInput: View {
    let title:String
    let addTitle:String
    @Binding var text:String;
    var itemNum:Int? = nil;
    var icon:String = "\u{e91f}"
    let onSave:() -> Void
    
    @State var showSheet:Bool = false;

    var body : some View {
        EditableTextSheetLayout(title: title, text: $text, showSheet: $showSheet, onSave:onSave, itemNum:itemNum) {
            BarButton(icon: icon, text: addTitle, action: {
                text = "";
                showSheet.toggle()
            })
        }
    }
}

struct BarButtonTriggeringMultiImageTextInput: View {
    let title:String
    let addTitle:String
    @Binding var pictures:[Picture]
    @Binding var text:String;
    var icon:String = "\u{e91f}"
    let onSave:() -> Void
    
    @State var showSheet:Bool = false;

    var body : some View {
        EditableTextAndMultiImageSheetLayout(title: title, text: $text, pictures:$pictures, showSheet: $showSheet, onSave:onSave) {
            BarButton(icon: icon, text: addTitle, action: {
                text = "";
                showSheet.toggle()
            })
        }
    }
}

struct EditableTextRow<Content: View>: View {
    let title:String;
    @Binding var text:String;
    let onSave:() -> Void
    @ViewBuilder let content: Content;
    
    @State var showSheet:Bool = false;
    
    var body : some View {
        EditableTextSheetLayout(title: title, text: $text, showSheet: $showSheet, onSave:onSave) {
            VStack(alignment: .trailing, spacing: 4) {
                content
            }
            .padding(12)
            .background(Colors.FillStaticFillPrimary)
            .cornerRadius(8)
            .shadow(color: Colors.ShadowMed, radius: 8, x: 0, y: 8)
            .shadow(color: Colors.ShadowEdge, radius: 4, x: 0, y: 0)
            .onTapGesture {
                showSheet.toggle()
            }
        }
    }
}


struct OfferCourseNameSuggestions : View {
    @Binding var text:String;
    let suggestions:[CourseNameSuggestion]
    
    @State var currentSuggestion:CourseNameSuggestion?
    
    init(text: Binding<String>, numCourses: Int) {
        self._text = text
        if numCourses <= 3 {
            self.suggestions = CourseNameSuggestion.earlyCourses
        } else if numCourses <= 5 {
            self.suggestions = CourseNameSuggestion.middleCourses
        } else {
            self.suggestions = CourseNameSuggestion.lateCourses
        }
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 0) {
                FoodieText("Suggestions:", Colors.TextStaticTextSecondary, size:12, weight:.semibold)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .padding(.horizontal, 8)
            .padding(.top, 16)
            .padding(.bottom, 4)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            WrappingHStack(suggestions.sorted(by: {$0.displayName() < $1.displayName()}), id: \.self) { suggestion in
                suggestionPill(value: suggestion)
            }
            .padding(8)
        }
    }
    
    func suggestionPill(value:CourseNameSuggestion) -> some View {
        VStack {
            Button {
                text = value.displayName()
            } label: {
                HStack(alignment: .center, spacing: 4) {
                    FoodieText(value.displayName(), Colors.TextStaticTextSecondary, size:12, weight:.bold)
                }
                .fixedSize(horizontal: true, vertical: false)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .frame(height: 28, alignment: .leading)
            }
            .buttonStyle(SuggestionButtonStyle(text:value.displayName()))

            

            
            Spacer()
                .frame(height:8)
        }
        .frame(height:36)
    }
    
    private struct SuggestionButtonStyle: ButtonStyle {
        let text:String;
        
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .background(configuration.isPressed ? Colors.FillActionFillActionSelected : Colors.FillStaticFillSecondary)
                .cornerRadius(80)
                .overlay() {
                    FoodieText(text, configuration.isPressed ? Colors.TextActionTextActionSelectedInvert : Colors.TextStaticTextSecondary, size:12, weight:.bold)
                }
        }
    }
}


struct AddCourseEditableTextSheetLayout<Content: View>: View {
    let title:String;

    @Binding var text:String;
    @Binding var showSheet:Bool;

    @State private var newText:String = ""
    
    var onSave:() -> Void = { }

    @ViewBuilder let content: Content;

    var body: some View {
        content
            .sheet(isPresented: $showSheet) {
                EditSheetView(
                    topLeftButton: {
                        SmallActionBackButton(icon: "\u{e900}") {
                            showSheet.toggle()
                        }
                    },
                    topRightButton: {
                        SmallClearButton(disabled: { newText.isEmpty }) {
                            newText = ""
                        }
                    },
                    mainView: {
                        EditSheetComponentMainTextControl(title: title, text: $newText)
                    },
                    bottomButtons: {
                        EditSheetComponentBottomSingleButton(
                            saveButton: {
                                EditSheetComponentSaveButton(
                                    disabledClosure: { text == newText },
                                    action: {
                                        text = newText
                                        showSheet.toggle()
                                        onSave()
                                    }
                                )
                            }
                        )
                    }
                )
                .onAppear() {
                    newText = text
                }
            }
    }
}


struct EditableTextSheetLayout<Content: View>: View {
    let title:String;
    
    @Binding var text:String;
    @Binding var showSheet:Bool;
    
    @State private var newText:String = ""
    
    var onSave:() -> Void = { }

    var itemNum:Int? = nil;
    
    @ViewBuilder let content: Content;

    var body: some View {
        content
            .sheet(isPresented: $showSheet) {
                EditSheetView(
                    topLeftButton: {
                        SmallActionBackButton(icon: "\u{e900}") {
                            showSheet.toggle()
                        }
                    },
                    topRightButton: {
                        SmallClearButton(disabled: { newText.isEmpty }) {
                            newText = ""
                        }
                    },
                    mainView: {
                        EditSheetComponentMainTextControl(title: title, text: $newText, itemNum:itemNum)
                    },
                    bottomButtons: {
                        EditSheetComponentBottomSingleButton(
                            saveButton: {
                                EditSheetComponentSaveButton(
                                    disabledClosure: { text == newText },
                                    action: {
                                        text = newText
                                        showSheet.toggle()
                                        onSave()
                                    }
                                )
                            }
                        )
                    }
                )
                .onAppear() {
                    newText = text
                }
            }
    }
}

struct EditableTextAndMultiImageSheetLayout<Content: View>: View {
    let title:String;
    @Binding var text:String;
    @Binding var pictures:[Picture]
    @Binding var showSheet:Bool;
    let onSave:() -> Void
    
    @State var newText:String = ""
    @State var newPictures:[Picture] = []
    
    @ViewBuilder let content: Content;
    
    var body: some View {
        content
            .sheet(isPresented: $showSheet) {
                EditSheetView(
                    topLeftButton: {
                        SmallActionBackButton(icon: "\u{e900}") {
                            showSheet.toggle()
                        }
                    },
                    topRightButton: {
                        SmallClearButton(disabled: { newText.isEmpty }) {
                            newText = ""
                        }
                    },
                    mainView: {
                        EditSheetComponentMainTextAndMultiImageControl(
                            title: title,
                            text: $newText,
                            pictures: $newPictures
                        )
                    },
                    bottomButtons: {
                        EditSheetComponentBottomSingleButton(
                            saveButton: {
                                EditSheetComponentSaveButton(
                                    disabledClosure: {
                                        (newText == text && newPictures == pictures)
                                        ||
                                        (newText.isEmpty && newPictures.isEmpty)
                                    },
                                    action: {
                                        text = newText
                                        pictures = newPictures
                                        onSave()
                                        showSheet.toggle()
                                    }
                                )
                            }
                        )
                    }
                )
                .onAppear() {
                    newText = text;
                    newPictures = pictures
                }
            }
    }
}
