//
//  ClassListViewModel.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Combine
import Foundation
import UserSDK

public final class ClassListViewModel: ObservableObject {
    @Published var studiedClasses: [GenericCourse] = []
    
    let goBackTap = PassthroughSubject<Void, Never>()
    
    public let navigateToUserAccount: AnyPublisher<Void, Never>
    
    public init() {
        self.navigateToUserAccount = goBackTap.eraseToAnyPublisher()
    }
}
