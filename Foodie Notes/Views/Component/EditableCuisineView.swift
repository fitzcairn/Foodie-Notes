//
//  EditableCuisineView.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/12/24.
//

import SwiftUI
import WrappingHStack


struct EditableCuisineView: View {
    let title:String;
    @Binding var cuisines:[Cuisine];
    let onSave:() -> Void;
    
    var body : some View {
        EditableCuisineComponent(title, $cuisines, onSave) {
            HStack(alignment: .top, spacing: 8) {
                HStack(alignment: .center, spacing: 4) {
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .frame(width: 28, height: 28, alignment: .center)
                .cornerRadius(80)
                .overlay(
                    ZStack {
                        FoodieIcon("\u{e91f}", Colors.BorderActionBorderAction, padding:0)
                        RoundedRectangle(cornerRadius: 80)
                            .inset(by: 0.75)
                            .stroke(Colors.BorderActionBorderAction, lineWidth: 1.5)
                    }
                )
                
                WrappingHStack(cuisines, id: \.self) { cuisine in
                    CuisinePill(cuisine, selected: true, disabled: true)
                }
            }
        }
    }
}

private struct CuisinePill: View {
    let cuisine:Cuisine;
    let disabled:Bool;
    @State var selected:Bool = false;
    let onSelectClosure:() -> Void;


    init(_ cuisine: Cuisine, selected: Bool = false, disabled:Bool = false, onSelectClosure: @escaping () -> Void = {}) {
        self.cuisine = cuisine
        self.onSelectClosure = onSelectClosure;
        self._selected = State.init(initialValue: selected)
        self.disabled = disabled;
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 4) {
                FoodieText(cuisine.displayName, selected ? Colors.TextActionTextActionSelectedInvert : Colors.TextStaticTextSecondary, size:12, weight:.bold)
            }
            .fixedSize(horizontal: true, vertical: false)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .frame(height: 28, alignment: .leading)
            .background(selected ? Colors.FillActionFillActionSelected : Colors.FillStaticFillSecondary)
            .cornerRadius(80)
            Spacer()
                .frame(height:8)
        }
        .frame(height:36)
        .onTapGesture {
            if !disabled {
                selected.toggle()
                onSelectClosure()
            }
        }
    }
}

private struct EditableCuisineComponent<Content: View>: View {
    let title:String;
    @Binding var cuisines:[Cuisine];
    let onSave:() -> Void;
    let content: Content;
    
    @State var showSheet:Bool = false;
    @State private var newCuisines:[Cuisine];
    @State private var filterText:String = "";
    
    init(_ title:String, _ cuisines:Binding<[Cuisine]>, _ onSave: @escaping () -> Void, @ViewBuilder _ content: () -> Content) {
        self.title = title;
        self._cuisines = cuisines;
        self.onSave = onSave;
        self.content = content()
        self._newCuisines = State.init(initialValue: cuisines.wrappedValue)
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
                },
                editView: {
                    FoodieText(title, Colors.TextStaticTextSecondary, size:16, weight:.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                    
                    VerticalSpace(8)
                    
                    cuisineSelectionControl
                },
                saveButton: { },
                renderSave: false
            )
            .onAppear() {
                newCuisines = cuisines;
            }
        }
    }
    
    private var cuisineSelectionControl: some View {
        VStack(alignment: .leading) {
            SearchBox(searchText: $filterText)
            
            VerticalSpace(8)
            
            ZStack {
                ScrollView() {
                    WrappingHStack(Cuisine.allCases.filter() { filterText.isEmpty ? true :  $0.displayName.range(of:filterText, options: .caseInsensitive) != nil }, id: \.self) { cuisine in
                        CuisinePill(cuisine, selected: newCuisines.contains(cuisine)) {
                            if let index = newCuisines.firstIndex(of: cuisine) {
                                newCuisines.remove(at: index)
                            } else {
                                newCuisines.append(cuisine)
                            }
                        }
                    }
                    .padding(8)
                }
                
                BottomFade()
                
                VStack(alignment: .trailing, spacing: 16) {
                    Spacer()
                    
                    HStack {
                        Spacer ()
                        LargeActionRedButton(icon:"\u{e905}") {
                            cuisines = newCuisines;
                            onSave()
                            showSheet.toggle()
                        }
                    }
                    .padding(.horizontal, 32)
                }
            }
        }
    }
}
