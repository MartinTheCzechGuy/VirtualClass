//
//  LoginViewModel.swift
//  
//
//  Created by Martin on 10.11.2021.
//

import Combine
import CombineExt
import Foundation
import UserSDK

public final class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var loginInvalidStatus: TextFieldErrorCaptionView.Status? = nil
    
    let registerNewAccountTap = PassthroughSubject<Void, Never>()
    let loginTap = PassthroughSubject<(email: String, password: String), Never>()
    let goBackTap = PassthroughSubject<Void, Never>()
    
    public let navigateToWelcomeScreen: AnyPublisher<Void, Never>
    public let navigateToDashboard: AnyPublisher<Void, Never>
    public let navigateToRegistration: AnyPublisher<Void, Never>
    
    private let loginSuccessfulSubject = PassthroughSubject<Void, Never>()
    private var bag = Set<AnyCancellable>()
    private let handleLoginUseCase: HandleLoginUseCaseType
    
    public init(handleLoginUseCase: HandleLoginUseCaseType) {
        self.handleLoginUseCase = handleLoginUseCase
        self.navigateToWelcomeScreen = goBackTap.eraseToAnyPublisher()
        self.navigateToRegistration = registerNewAccountTap.eraseToAnyPublisher()
        self.navigateToDashboard = loginSuccessfulSubject.eraseToAnyPublisher()

        let loginEvaluation = loginTap
            .flatMap { [weak self] email, password -> AnyPublisher<LoginValidationResult, Never> in
                guard let self = self else {
                    return Empty().eraseToAnyPublisher()
                }
                
                return self.handleLoginUseCase.login(email: email, password: password)                
            }
            .share(replay: 1)
        
        loginEvaluation
            .compactMap { validationResult -> Void? in
                if case .validData = validationResult { return () }; return nil
            }
            .sink(
                receiveValue: { [weak self] _ in
                    self?.loginSuccessfulSubject.send()
                }
            )
            .store(in: &bag)
        
        loginEvaluation
            .compactMap { evaluationResult -> TextFieldErrorCaptionView.Status? in
                switch evaluationResult {
                case .invalidPassword:
                    return .invalidPassword
                case .invalidEmail:
                    return .invalidEmail
                case .invalidCredentials:
                    return .invalidCredentials
                case .validData:
                    return nil
                case .errorLoadingData:
                    return .errorStoringCredentials
                case .accountDoesNotExist:
                    return .unknownEmail
                }
            }
            .assign(to: \.loginInvalidStatus, on: self)
            .store(in: &bag)
    }
}

extension LoginViewModel: Identifiable {}
