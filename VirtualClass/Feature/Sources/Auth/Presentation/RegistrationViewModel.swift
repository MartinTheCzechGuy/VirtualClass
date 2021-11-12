//
//  RegistrationViewModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine

public final class RegistrationViewModel: ObservableObject {
    
    let goBackTap = PassthroughSubject<Void, Never>()
    let registerTap = PassthroughSubject<RegistrationData, Never>()
    let alreadyHaveAccountTap = PassthroughSubject<Void, Never>()
    
    public let navigateToDashboard: AnyPublisher<Void, Never>
    public let navigateToWelcomeScreen: AnyPublisher<Void, Never>
    public let navigateToSignIn: AnyPublisher<Void, Never>

    public init() {
        self.navigateToWelcomeScreen = goBackTap.eraseToAnyPublisher()
        self.navigateToSignIn = alreadyHaveAccountTap.eraseToAnyPublisher()
        
        let registrationResult = registerTap
            .map { _ in true }
            .share()
        
        self.navigateToDashboard = registrationResult
            .filter { $0 }
            .map{ _ in return }
            .eraseToAnyPublisher()
    }
}

extension RegistrationViewModel: Identifiable {}
