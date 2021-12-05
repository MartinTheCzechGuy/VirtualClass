//
//  AuthView.swift
//  
//
//  Created by Martin on 14.11.2021.
//

import Combine
import InstanceProvider
import SwiftUI

public struct AuthView: View {
    
    @ObservedObject private var coordinator: AuthCoordinator
    
    private let instanceProvider: InstanceProvider
    
    init(
        instanceProvider: InstanceProvider,
        coordinator: AuthCoordinator
    ) {
        self.instanceProvider = instanceProvider
        self.coordinator = coordinator
    }
    
    public var body: some View {
        instanceProvider.resolve(WelcomeView.self)
            .fullScreenCover(item: $coordinator.activeScreen) { activeScreen in
                switch activeScreen {
                case .login:
                    instanceProvider.resolve(LoginView.self)
                case .registration:
                    instanceProvider.resolve(RegistrationView.self)
                }
            }
    }
}
