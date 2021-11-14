//
//  WelcomeViewModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine
import Foundation

public final class WelcomeViewModel: ObservableObject {
    
    #warning("TODO: tohle je v podstate duplikatni kod, ve smyslu, ze by si mohl v coordinatoru rovnou poslouchat signInTap, ale nemel bys ... nejak to schovat to Actions etc struktur?")
    let signInTap = PassthroughSubject<Void, Never>()
    let signUpTap = PassthroughSubject<Void, Never>()
    
    public let navigateToLogin: AnyPublisher<Void, Never>
    public let navigateToRegistration: AnyPublisher<Void, Never>

    private var bag = Set<AnyCancellable>()
        
    public init() {
        self.navigateToLogin = signInTap.eraseToAnyPublisher()
        self.navigateToRegistration = signUpTap.eraseToAnyPublisher()
        
        print("Welcome view model init")
    }
    
    deinit {
        print("Welcome view model deinit")
    }
}
