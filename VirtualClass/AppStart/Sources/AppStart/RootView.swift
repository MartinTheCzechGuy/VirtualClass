//
//  RootView.swift
//  
//
//  Created by Martin on 10.11.2021.
//

import InstanceProvider
import SwiftUI
import Login

public struct RootView: View {
    
    private let appStart: AppStart
    
    public init(appStart: AppStart) {
        self.appStart = appStart
    }
    
    public var body: some View {
        let instanceProvider: InstanceProvider = appStart.startApp()
        
        instanceProvider.resolve(LoginView.self)
    }
}
