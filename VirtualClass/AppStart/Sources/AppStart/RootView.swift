//
//  RootView.swift
//  
//
//  Created by Martin on 10.11.2021.
//

import InstanceProvider
import SwiftUI

public struct RootView: View {
    
    private let appStart: AppStart
    
    public init(appStart: AppStart) {
        self.appStart = appStart
    }
    
    public var body: some View {
        appStart.startApp()
        
        return instanceProvider.resolve(MainView.self)
    }
}
