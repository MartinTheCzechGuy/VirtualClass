//
//  UserAccountViewModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine
import UserSDK

public final class UserAccountViewModel: ObservableObject {
    let personalInfoTap = PassthroughSubject<Void, Never>()
    let currentlyStudiedClassesTap = PassthroughSubject<Void, Never>()
    let addNewClassTap = PassthroughSubject<Void, Never>()
    let logoutTap = PassthroughSubject<Void, Never>()
    
    let navigateToClassSearch: AnyPublisher<Void, Never>
    let navigateToPersonalInfo: AnyPublisher<Void, Never>
    let navigateToClassOverview: AnyPublisher<Void, Never>
    
    private let handleLogOutUseCase: HandleLogOutUseCaseType
    
    private var bag = Set<AnyCancellable>()
    
    public init(handleLogOutUseCase: HandleLogOutUseCaseType) {
        self.handleLogOutUseCase = handleLogOutUseCase
        self.navigateToClassSearch = addNewClassTap.eraseToAnyPublisher()
        self.navigateToClassOverview = currentlyStudiedClassesTap.eraseToAnyPublisher()
        self.navigateToPersonalInfo = personalInfoTap.eraseToAnyPublisher()
        
        logoutTap
            .sink(receiveValue: { [weak self] _ in
                self?.handleLogOutUseCase.logout()
            })
            .store(in: &bag)
    }
}
