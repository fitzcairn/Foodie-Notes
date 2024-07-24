//
//  NetworkService.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/24/24.
//

import Foundation
import Network

@Observable
final class NetworkService {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    var isConnected = false
    
    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        networkMonitor.start(queue: workerQueue)
    }
}
