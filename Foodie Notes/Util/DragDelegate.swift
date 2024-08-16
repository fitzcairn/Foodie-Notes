//
//  DragDelegate.swift
//  Foodie Notes
//
//  Created by Steve Martin on 8/16/24.
//

import SwiftUI
import SwipeActions
import UniformTypeIdentifiers

struct DragDelegate<Item: Equatable>: DropDelegate {
    let dropIndex:Int
    @Binding var listData:[Item]
    @Binding var dragIndex: Int?
    var onSave:() -> Void = {}
        
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
        onSave()
        dragIndex = nil
        return true
    }
}
