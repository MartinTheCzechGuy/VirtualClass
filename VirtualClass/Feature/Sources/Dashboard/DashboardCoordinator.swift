//
//  DashboardCoordinator.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine
import UserAccount

public final class DashboardCoordinator: ObservableObject {
        
    // Actions
    
    public let didLogout: AnyPublisher<Void, Never>
    
    // Private
    
    @Published private var userAccountCoordinator: UserAccountCoordinator
    
    private let didLogoutSubject = PassthroughSubject<Void, Never>()
    private var bag = Set<AnyCancellable>()
    
    public init(
        userAccountCoordinator: UserAccountCoordinator
    ) {
        self.userAccountCoordinator = userAccountCoordinator
        self.didLogout = didLogoutSubject.eraseToAnyPublisher()
        
        setupBindings()
    }
    
    private func setupBindings() {
        userAccountCoordinator.didLogout
            .sink(receiveValue: { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.didLogoutSubject.send()
            })
            .store(in: &bag)
    }
}
