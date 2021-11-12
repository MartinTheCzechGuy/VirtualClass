//
//  UserAccountViewModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine

public final class UserAccountViewModel: ObservableObject {
    let personalInfoTap = PassthroughSubject<Void, Never>()
    let currentlyStudiedClassesTap = PassthroughSubject<Void, Never>()
    let addNewClassTap = PassthroughSubject<Void, Never>()
    
    let navigateToClassSearch: AnyPublisher<Void, Never>
    let navigateToPersonalInfo: AnyPublisher<Void, Never>
    let navigateToClassOverview: AnyPublisher<Void, Never>
    
    public init() {
        self.navigateToClassSearch = addNewClassTap.eraseToAnyPublisher()
        self.navigateToClassOverview = currentlyStudiedClassesTap.eraseToAnyPublisher()
        self.navigateToPersonalInfo = personalInfoTap.eraseToAnyPublisher()
    }
}
