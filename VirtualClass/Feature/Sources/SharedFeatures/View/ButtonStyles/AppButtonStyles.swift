//
//  AppButtonStyles.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import SwiftUI

public struct AppRedButtonStyle: ButtonStyle {
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 200, alignment: .center)
            .foregroundColor(.white)
            .padding()
            .background(Color.red)
            .cornerRadius(8)
    }
}

public struct AppGoldenButtonStyle: ButtonStyle {
    
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 200, alignment: .center)
            .foregroundColor(.white)
            .padding()
            .background(Color.golden)
            .cornerRadius(8)
    }
}

public struct AppBlackButtonStyle: ButtonStyle {

    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 200, alignment: .center)
            .foregroundColor(.white)
            .padding()
            .background(Color.black)
            .cornerRadius(8)
    }
}
