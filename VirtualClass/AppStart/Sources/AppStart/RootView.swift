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
        let instanceProvider: InstanceProvider = appStart.startApp()
        
        Text("Hello world")
//        instanceProvider.resolve(CitySearchView.self)
    }
}
