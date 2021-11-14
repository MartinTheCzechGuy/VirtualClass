//
//  PersonalInfoViewModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine
import UserSDK

public final class PersonalInfoViewModel: ObservableObject {
    
    let saveChangesTap = PassthroughSubject<Void, Never>()
    let goBackTap = PassthroughSubject<Void, Never>()
    
    let navigateToUserAccount: AnyPublisher<Void, Never>
    
    private let updateUserProfileUseCase: UpdateUserProfileUseCaseType
    
    public init(updateUserProfileUseCase: UpdateUserProfileUseCaseType) {
        self.updateUserProfileUseCase = updateUserProfileUseCase
        
        self.navigateToUserAccount = goBackTap
            .merge(with: saveChangesTap)
            .eraseToAnyPublisher()
    }
}
