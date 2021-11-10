//
//  VirtualClassApp.swift
//  VirtualClass
//
//  Created by Martin on 10.11.2021.
//

import AppStart
import SwiftUI

@main
struct VirtualClassApp: App {
    
    private let appStart = AppStart()

    var body: some Scene {
        WindowGroup {
            RootView(appStart: appStart)
        }
    }
}
