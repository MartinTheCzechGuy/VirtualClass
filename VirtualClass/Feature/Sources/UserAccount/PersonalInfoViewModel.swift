//
//  PersonalInfoViewModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine

public final class PersonalInfoViewModel: ObservableObject {
    
    let saveChangesTap = PassthroughSubject<Void, Never>()
    let goBackTap = PassthroughSubject<Void, Never>()
    
    let navigateToUserAccount: AnyPublisher<Void, Never>
    
    public init() {
        self.navigateToUserAccount = goBackTap
            .merge(with: saveChangesTap)
            .eraseToAnyPublisher()
    }
}
