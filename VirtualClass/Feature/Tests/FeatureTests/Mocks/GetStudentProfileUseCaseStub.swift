//
//  GetStudentProfileUseCaseStub.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import UserSDK

final class GetStudentProfileUseCaseStub: GetStudentProfileUseCaseType {
    
    private let profile: AnyPublisher<GenericStudent?, GetStudentProfileError>
    
    init(profile: AnyPublisher<GenericStudent?, GetStudentProfileError>) {
        self.profile = profile
    }
    
    var userProfile: AnyPublisher<GenericStudent?, GetStudentProfileError> {
        profile
    }
}
