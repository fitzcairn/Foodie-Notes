//
//  ServiceConfig.swift
//  Foodie Notes
//
//  Created by Steve Martin on 7/21/24.
//

import Foundation


protocol AppService {

    // All of our services are singletons.
    static var shared: AppService { get }
}
