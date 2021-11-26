//
//  HandleLogOutUseCaseStub.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import UserSDK

final class HandleLogOutUseCaseStub: HandleLogOutUseCaseType {
    
    private(set) var haveBeenCalled = false
    
    func logout() {
        haveBeenCalled = true
    }
}
