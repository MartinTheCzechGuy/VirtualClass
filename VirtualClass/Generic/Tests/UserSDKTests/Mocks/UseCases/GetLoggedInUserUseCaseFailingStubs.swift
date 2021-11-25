//
//  GetLoggedInUserUseCaseFailingStubs.swift
//  
//
//  Created by Martin on 25.11.2021.
//

@testable import UserSDK


final class GetLoggedInUserUseCaseStub: GetLoggedInUserUseCaseType {
    var email: String? {
        "e@mail.cz"
    }
}

final class GetLoggedInUserUseCaseFailingStub: GetLoggedInUserUseCaseType {
    var email: String? {
        nil
    }
}
