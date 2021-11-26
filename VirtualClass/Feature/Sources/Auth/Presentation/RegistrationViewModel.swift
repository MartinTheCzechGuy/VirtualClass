//
//  RegistrationViewModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine
import CombineExt
import Foundation
import UserSDK

public final class RegistrationViewModel: ObservableObject {
    
    @Published var registrationInvalidStatus: TextFieldErrorCaptionView.Status? = nil
    
    let goBackTap = PassthroughSubject<Void, Never>()
    let registerTap = PassthroughSubject<RegistrationData, Never>()
    let alreadyHaveAccountTap = PassthroughSubject<Void, Never>()
    
    public let navigateToDashboard: AnyPublisher<Void, Never>
    public let navigateToWelcomeScreen: AnyPublisher<Void, Never>
    public let navigateToSignIn: AnyPublisher<Void, Never>
    
    private let tada = PassthroughSubject<Void, Never>()
    
    private var bag = Set<AnyCancellable>()

    private let handleRegistrationUseCase: HandleUserRegistrationUseCaseType
    
    public init(handleRegistrationUseCase: HandleUserRegistrationUseCaseType) {
        self.handleRegistrationUseCase = handleRegistrationUseCase
        self.navigateToWelcomeScreen = goBackTap.eraseToAnyPublisher()
        self.navigateToSignIn = alreadyHaveAccountTap.eraseToAnyPublisher()
        self.navigateToDashboard = tada.eraseToAnyPublisher()
        
        let registrationResult = registerTap
            .flatMap { [weak self] registrationForm -> AnyPublisher<RegistrationValidationResult, Never> in
                guard let self = self else { return Just(.errorStoringCredentials).eraseToAnyPublisher() }
                
                return self.handleRegistrationUseCase.register(
                    form: .init(
                        email: registrationForm.email,
                        password1: registrationForm.password1,
                        password2: registrationForm.password2,
                        name: registrationForm.name
                    )
                )
            }
            .share(replay: 1)

        registrationResult
            .compactMap { evaluationResult -> TextFieldErrorCaptionView.Status? in
                switch evaluationResult {
                case .passwordsDontMatch:
                    return .nonMatchingPasswords
                case .invalidPassword:
                    return .invalidPassword
                case .invalidEmail:
                    return .invalidEmail
                case .emailAlreadyUsed:
                    return .emailAlreadytaken
                case .validData:
                    return nil
                case .errorStoringCredentials:
                    return .errorStoringCredentials
                }
            }
            .assign(to: \.registrationInvalidStatus, on: self)
            .store(in: &bag)
        
        registrationResult
            .compactMap { evaluationResult -> Void? in
                guard case .validData = evaluationResult else {
                    return nil
                }
                
                return ()
            }
            .sink(receiveValue: { [weak self] _ in
                self?.tada.send()
            })
            .store(in: &bag)
    }
}

extension RegistrationViewModel: Identifiable {}
