//
//  WrappedStruct.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/16/24.
//

import Foundation

class WrappedStruct<T>: ObservableObject {
    @Published var item: T
    
    init(withItem item:T) {
        self.item = item
    }
}
