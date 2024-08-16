//
//  SwipeableDraggableList.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/16/24.
//

import SwiftUI
import SwipeActions
import UniformTypeIdentifiers

struct SwipeableDraggableList<Content: View, Item: Equatable & Hashable>: View {
    @Binding var data:[Item]
    var onSave:() -> Void = {}
    @ViewBuilder var content: (Int) -> Content

    @State private var draggingIndex: Int? = nil;

    init(data:Binding<[Item]>, onSave:@escaping () -> Void, @ViewBuilder content: @escaping (Int) -> Content) {
        self._data = data
        self.onSave = onSave
        self.content = content
    }
    
    var body: some View {
        SwipeViewGroup {
            ForEach(Array(zip(data.indices, data)), id: \.0) { index, item in
                content(index)
                .padding(.bottom, -2)
                .onDrag {
                    self.draggingIndex = index
                    return NSItemProvider(object: NSString())
                }
                .onDrop(of: [UTType.text], delegate: DragDelegate(dropIndex: index, listData: $data, dragIndex: $draggingIndex))
            }
            .onMove(perform: {_, _  in })
            .onChange(of: data) {
                onSave()
            }
            .transition(.asymmetric(insertion: .opacity,
                                    removal: .slide))
            .id(data.count)
        }
    }
}

private struct DragDelegate2<Item: Equatable>: DropDelegate {
    let dropIndex:Int
    @Binding var listData:[Item]
    @Binding var dragIndex: Int?
        
    func dropEntered(info: DropInfo) {
     }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        if dragIndex != nil && dropIndex != dragIndex! {
            let from = dragIndex!
            let to = dropIndex
            listData.move(fromOffsets: IndexSet(integer: from),
                          toOffset: to > from ? to + 1 : to)
        }
        dragIndex = nil
        return true
    }
}
