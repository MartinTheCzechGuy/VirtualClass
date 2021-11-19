//
//  WelcomeViewModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine

public final class WelcomeViewModel: ObservableObject {
    
    // MARK: - View to View Model
    
    let signInTap = PassthroughSubject<Void, Never>()
    let signUpTap = PassthroughSubject<Void, Never>()
    
    // MARK: - View Model to Coordinaotr
    
    public struct Action {
        let loginTap: AnyPublisher<Void, Never>
        let registrationTap: AnyPublisher<Void, Never>
    }
    
    public lazy var actions: Action = Action(
        loginTap: signInTap.eraseToAnyPublisher(),
        registrationTap: signUpTap.eraseToAnyPublisher()
    )
                
    public init() {}
}
